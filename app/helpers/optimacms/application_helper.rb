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

    def block_with_edit(name, tpl_filename, opts={})

      # find template
      row_tpl = Optimacms::PageServices::TemplateService.get_by_name(name)

      links_edit = Optimacms::PageServices::TemplateService.get_links_edit(row_tpl)


      # render
      opts.merge!({optimacms_filename: tpl_filename, optimacms_tpl: row_tpl})
      opts[:optimacms_admin_links_edit] = links_edit

      return render template: 'optimacms/admin_page_edit/block_edit', :locals => opts

=begin
      content_tag(:div, class: "debug_box") do
        #(link_to "edit", "/admin/templates/#{row_tpl.id}/edit", target: "_blank")+
        content_tag(:div, class: "debug_commands") do
          #html_links = links_data.map{|r| r[:link_html]}.join("<br>").html_safe
          html_links = links_edit.map{|r| URI::join(root_url, Optimacms.config.admin_namespace, r[:path])}.join("<br>").html_safe

          ((link_to "edit block", "/admin/templates/#{row_tpl.id}/edit", target: "_blank")+"<br>".html_safe+html_links).html_safe
        end+
        #block(name, opts)
        (render file: tpl_filename, locals: opts)
      end
=end

    end




    def block(name, opts={})
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

      # render from file
      if File.exists? f
        #opts[:file] = f
        #return render opts

        if current_cms_admin_user
          #return block_with_edit file: f, locals: opts
          return block_with_edit name, f, opts
        else
          return render file: f, locals: opts
        end

      end


      # default render
      render name, opts
    end


    def msg
      Optimacms::Resource
    end


  end
end
