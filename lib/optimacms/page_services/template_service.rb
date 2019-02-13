module Optimacms
  module PageServices
    class TemplateService

      def self.get_by_name(name)
        row = Template.where(basepath: name).first

        row
      end


      def self.get_file_for_template(template, lang='', opts={})
        template.basedirpath + template.filename_base + filename_lang_postfix(lang) + filename_ext_with_dot(template.tpl_format)
      end

      def self.filename_lang_postfix(lang)
        lang = lang.to_s
        return '' if lang==''
        return '.'+lang
      end

      def self.filename_ext(format)
        Template::EXTENSIONS[format]
      end

      def self.filename_ext_with_dot(format)
        ext = filename_ext(format)
        ext = '.'+ext unless ext.blank?
        ext
      end


      def self.get_file_for_path(path, opts={})
        file_path = nil

        name = path
        lang = opts[:lang] || ''
        dir_base = 'app/views'
        current_dir = opts[:current_dir] || ''



        # try. HTML file in the current folder
        #f = File.join(Dir.pwd, dir_base, d, name+'.html')

        # more trials
        # extensions
        extensions = ['', '.html.haml', '.html.erb', '.html']

        #
        names = []

        #
        parts = name.split /\//

        parts[-1] = '_'+parts[-1]
        name2 = parts.join('/')

        #
        names << [current_dir, name] if current_dir != ''
        names << ["", name]

        names << [current_dir, name2] if current_dir != ''
        names << ["", name2]

        f = nil

        # try 2
        names.each do |p|
          extensions.each do |ext|
            f = nil

            # with lang
            if (lang || '')!=''
              cand_basepath = File.join(p[0], p[1]+'.'+lang.to_s+ext)
              ff = File.join(Dir.pwd, dir_base, cand_basepath)
              if File.exists? ff
                file_path = cand_basepath
                f = ff
                break
              end
            end

            # without lang
            cand_basepath = File.join(p[0], p[1]+ext)
            ff = File.join(Dir.pwd, dir_base, cand_basepath)
            if File.exists? ff
              file_path = cand_basepath
              f = ff
            end
          end

          #
          break if f && File.exists?(f)
        end

        return file_path
      end

      ###



      def self.get_links_edit(tpl)

        f_meta = File.join(File.dirname(tpl.fullpath), tpl.basename+".meta.yml")

        return [] unless File.exists?(f_meta)

        data = YAML.load(File.read(f_meta))

        links = data['links'] || []


        links

      end

      def self.get_tpl_data_relations(tpl)

        # data relations
        tpl_data_relations = {}
        if row_tpl
          tpl_data_relations = row_tpl.data_relations.all.index_by { |t| t.var_name }
        end


        # map locals and edit links
        links_data = []

        opts.each do |_var_name, v|
          var_name = _var_name.to_s

          next unless tpl_data_relations[var_name]
          data = tpl_data_relations[var_name]

          #if class exists $modelDecorator
          #klass = Object.const_get "#{p['model']}CmsDecorator"
          #objDecorator = klass.new(v)
          #classify.
          modelEditDecorator = "#{data.data_model_name}CmsDecorator".safe_constantize.new(v)

          next unless modelEditDecorator

          link_edit = modelEditDecorator.edit_path

          next unless link_edit

          #p = tpl_data_relations[var_name]
          #id = v.send(:id)
          #links_edit << {link: send(p["root_edit"]+"_path", id)}
          link_html = link_to("edit #{data.title}", link_edit, target: "_blank")
          links_data << {link: link_edit, link_html: link_html}
        end



      end

    end
  end
end

