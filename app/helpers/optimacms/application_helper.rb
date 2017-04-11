module Optimacms
  module ApplicationHelper

    #include ActionView::Helpers::ApplicationHelper
    #include SimpleFilter::FormsHelper


    def method_missing(method, *args, &block)
      main_app.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def tinymce_editor_insert_block
      '<pre>{{block:name:sub}}</pre>'
    end

    def eval_meta_string(s)
      eval('"'+s+'"')
    end

    def fix_quotes(s)
      s.gsub /"/, '\"'
    end

    def url_for(options = nil)
      #url_for
      # page processed by CMS
      if options.present? && options.kind_of?(Hash) && options[:controller]=='optimacms/pages' && options[:action]=='show'

        # get current page name
        page_name = options[:page_name] || controller.optimacms_pagedata.page.name
        if page_name.present?
          u = site_page_path(page_name, options)

          if u.present?
            return u
          end
        end
      end

      #
      return super(options)
    end



    def meta_tags(title=nil, keywords=nil, desc=nil)
      #s = 'news "11"'
      #s1 = s.gsub /"/, '\"'
      #s2 = eval('"'+s1+'"')
      title ||= eval_meta_string(fix_quotes(@optimacms_meta_title))
      keywords ||= eval_meta_string(@optimacms_meta_keywords)
      desc ||= eval_meta_string(@optimacms_meta_description)


    return %(<title>#{title}</title>
<meta name="keywords" content="#{keywords}"/>
<meta name="description" content="#{desc}"/>
      ).html_safe
      #content_tag(:title, title)+
      #content_tag(:meta, nil, content: keywords, name: 'keywords')+
      #content_tag(:meta, nil, content: desc, name: 'description')
    end

    def block_with_edit(name, opts={})

      # find template
      row_tpl = Optimacms::PageServices::TemplateService.get_by_name(name)

      # data relations
      tpl_data_relations = row_tpl.data_relations.all.index_by { |t| t.var_name }

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



      # render
      content_tag(:div, class: "debug_box") do
        #(link_to "edit", "/admin/templates/#{row_tpl.id}/edit", target: "_blank")+
        content_tag(:div, class: "debug_commands") do
          html_links = links_data.map{|r| r[:link_html]}.join("<br>").html_safe

          ((link_to "edit block", "/admin/templates/#{row_tpl.id}/edit", target: "_blank")+"<br>"+html_links).html_safe
        end+
        block(name, opts)
      end
    end

    def block(name, opts={})
      x = Dir.pwd
      #y = File.expand_path File.dirname(__FILE__)
      d = File.dirname(@optimacms_tpl)

      # extensions
      extensions = ['', '.html.haml', '.html.erb', '.html']


      # try. HTML file in the current folder
      f = File.join(Dir.pwd, 'app', 'views', d, name+'.html')
      #return render file: f if File.exists? f

      if !File.exists?(f)

        #
        names = []

        #
        parts = name.split /\//

        parts[-1] = '_'+parts[-1]
        name2 = parts.join('/')

        #
        names << [d, name]
        names << ["", name]

        names << [d, name2]
        names << ["", name2]


        # try 2
        names.each do |p|
          extensions.each do |ext|
            # with lang
            ff = File.join(Dir.pwd, 'app', 'views', p[0], p[1]+'.'+@pagedata.lang.to_s+ext)
            #(return render(file: f))      if File.exists? f
            if File.exists? ff
              f = ff
              break
            end

            # without lang
            ff = File.join(Dir.pwd, 'app', 'views', p[0], p[1]+ext)
            #(return render(file: f))      if File.exists? f
            if File.exists? ff
              f = ff
            end
          end

          #
          break if File.exists? f
        end
      end

      if File.exists? f
        #opts[:file] = f
        #return render opts
        return render file: f, locals: opts
      end


      # default render
      render name, opts
    end


    def msg
      Optimacms::Resource
    end


  end
end
