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

    def block(name, opts={})
      x = Dir.pwd
      #y = File.expand_path File.dirname(__FILE__)
      d = File.dirname(@optimacms_tpl)

      # extensions
      extensions = ['', '.html.haml', '.html.erb', '.html']


      # try. HTML file in the current folder
      f = File.join(Dir.pwd, 'app', 'views', d, name+'.html')
      return render file: f if File.exists? f

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
          f = File.join(Dir.pwd, 'app', 'views', p[0], p[1]+'.'+@pagedata.lang.to_s+ext)
          (return render file: f)      if File.exists? f

          # without lang
          f = File.join(Dir.pwd, 'app', 'views', p[0], p[1]+ext)
          (return render file: f)      if File.exists? f
        end
      end

      # default render
      return render name
    end


    def msg
      Optimacms::Resource
    end


  end
end
