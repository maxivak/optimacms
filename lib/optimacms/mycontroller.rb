module Optimacms
  module Mycontroller
    extend ActiveSupport::Concern


    ### rendering

    included do
      if respond_to?(:helper_method)
        helper_method :site_page_path
      end
    end

    def my_set_render
      @is_optimacms = true

    end

    def is_optimacms
      @is_optimacms
    end

    def default_render(*args)
      if self.controller_name!='pages' && !@optimacms_tpl.nil? && @is_optimacms
        render @optimacms_tpl, :layout=>@optimacms_layout and return
        #(render :text => "hello", :layout => @optimacms_layout) and return

        # http://stackoverflow.com/questions/21129587/ruby-on-rails-how-to-render-file-as-plain-text-without-any-html
        #render :plain will set the content type to text/plain
        #render :html will set the content type to text/html
        #render :body will not set the content type header.
        # render text: "some text". :plain does not work.
      end

      super
    end


    ### pagedata

    def optimacms_pagedata
      @pagedata
    end

    def optimacms_set_pagedata(_pagedata)
      @pagedata = _pagedata

    end

=begin
    def my_set_render_template(tpl_view, tpl_layout)
      @optimacms_tpl = tpl_view
      @optimacms_layout = tpl_layout
    end
=end
=begin
    def my_set_render_template(tpl_view)
      @optimacms_tpl = tpl_view
    end

    def my_set_render_layout(tpl_layout)
      @optimacms_layout = tpl_layout
    end



=end

=begin
    def my_set_meta(meta)
      @optimacms_meta_title = meta[:title]
      @optimacms_meta_keywords = meta[:keywords]
      @optimacms_meta_description = meta[:description]
    end
=end

    # page paths

    def site_page_path(name, p={})
      get_page_path(name, p)
    end

    def get_page_path(page_name, p={})
      # get from cache
      @cache_page_urls ||= {}
      url = @cache_page_urls.fetch(page_name.to_s, nil)

      if url.nil?
        page = Page.w_page.where(name: page_name).first
        url = page.url if page
      end

      return nil if url.nil?

      # set to cache
      @cache_page_urls ||= {}
      @cache_page_urls[page_name.to_s] = url

      #
      res = PageServices::PageRouteService.make_url url, p

      return nil if res.nil?

      '/'+res
    end

  end
end

