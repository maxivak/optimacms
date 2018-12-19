module Optimacms
  module PageServices
    class TemplateService

      def self.get_by_name(name)
        row = Template.where(basepath: name).first

        row
      end


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

