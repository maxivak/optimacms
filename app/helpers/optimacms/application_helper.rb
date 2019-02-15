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
      title ||= eval_meta_string(fix_quotes(@pagedata.meta[:title]))
      keywords ||= eval_meta_string(@pagedata.meta[:keywords])
      desc ||= eval_meta_string(@pagedata.meta[:description])

      #title ||= eval_meta_string(fix_quotes(@optimacms_meta_title))
      #keywords ||= eval_meta_string(@optimacms_meta_keywords)
      #desc ||= eval_meta_string(@optimacms_meta_description)


    return %(<title>#{title}</title>
<meta name="keywords" content="#{keywords}"/>
<meta name="description" content="#{desc}"/>
      ).html_safe
      #content_tag(:title, title)+
      #content_tag(:meta, nil, content: keywords, name: 'keywords')+
      #content_tag(:meta, nil, content: desc, name: 'description')
    end



    def optimacms_tpl
      @optimacms_tpl
    end


    def block(name, options={})
      source_name = options[:source] || @pagedata.page_template.source_name || Optimacms.config.default_content_source_name

      return Optimacms::Renderer::ContentRenderer.new(self, @pagedata).render_block( source_name, name, options)
    end


    def rblock(path, options={})
      source_name = options[:source] || Optimacms.config.default_content_source_name || @pagedata.page_template.source_name

      return Optimacms::Renderer::ContentRenderer.new(self, @pagedata).render_rblock( source_name, path, options)
    end

    def remote_asset_path(path, options={})
      source_name = options[:source] || Optimacms.config.default_content_source_name

      return Optimacms::Renderer::ContentRenderer.new(self, @pagedata).get_file_url( source_name, path, options)
    end


    def msg
      Optimacms::Resource
    end


  end
end
