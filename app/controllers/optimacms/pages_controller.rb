module Optimacms
  class PagesController < ApplicationController
    include Optimacms::MycontrollerControllerConcern

    def current_lang
      return I18n.locale
    end

    def show
      @path = params[:url]
      @pagedata = Optimacms::PageServices::PageRouteService.find_page_by_url(@path, current_lang)

      if @pagedata.page.nil?
        not_found and return
      end

      # page mapped to controller
      @pagedata.url_vars.each do |k,v|
        params[k] = v
      end

      # callback
      if respond_to?(:after_init_pagedata)
        send(:after_init_pagedata)
      end

      optimacms_set_pagedata @pagedata

      ## prepare template file
      # download file from remote source
      @pagedata.page_template.get_file

      # for remote template
      #unless @pagedata.page_template.is_local?
      #  prepend_view_path Optimacms.config.templates_remote_dir
      #end

      # render
      if @pagedata.page.content_page?
        # callbacks from main app
        if respond_to?(:before_page_render)
          send(:before_page_render)
        end

        render_options = {
            is_admin_edit: current_cms_admin_user
        }
        renderer = Optimacms::Renderer::Renderer.new(self, render_options)

        return renderer.render_page(@pagedata)
      else
        # process page with controller
        #@pagedata.generate_content

        # OK 2019-01-03
        #c = renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params, @pagedata.template_path, @pagedata.layout.basename)

        # new 2019-01-03
        #c = renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params, @pagedata.page_template.local_file.basepath, @pagedata.layout)
        c = renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params, @pagedata.page_template, @pagedata.layout)

        render inline: c
        return
      end
    end

    def renderActionInOtherController(controller,action,params, content_block, tpl_layout=nil)
      # include render into controller class
      #if current_cms_admin_user
      #  controller.send 'include', Optimacms::Renderer::AdminPageRenderer
      #  controller.send 'renderer_admin_edit'
      #end

      c = controller.new
      c.params = params

      # extend controller with cms stuff
      if !c.respond_to?(:is_optimacms, true)
        # controller is not known by OptimaCMS
        # TODO: raise exception
        # changed 2020-mar. commented
        #controller.send 'include', ::Optimacms::Mycontroller
        raise "Controller is not supported by OptimaCMS"
      end

      if !c.respond_to?(:render_base, true)
        controller.send :alias_method, :render_base, :render

        controller.send :define_method, "render" do |options = nil, extra_options = {}, &block|
          render_options = {
              is_admin_edit: current_cms_admin_user,
              function_default_render: :render_base
          }
          renderer = ::Optimacms::Renderer::Renderer.new(self, render_options)
          return renderer.render_page(@pagedata, options, extra_options, &block)

          #if current_cms_admin_user && @pagedata
          #  render_with_edit(options, extra_options, &block)
          #else
          #  render_base(options, extra_options, &block)
          #end
        end
      end

      # views
      #unless content_block.is_local?
      #  c.prepend_view_path Optimacms.config.templates_remote_dir
      #end

      #c.process_action(action, request)
      #c.dispatch(action, request)
      #c.send 'index_page'

      c.request = request
      #c.request.path_parameters = params.with_indifferent_access
      c.request.format = params[:format] || 'html'

      c.action_name = action
      c.response = ActionDispatch::Response.new

      c.send 'my_set_render'
      c.send 'optimacms_set_pagedata', @pagedata

      #c.process_action(action)
      c.dispatch(action, request, c.response)
      #c.process_action(action, tpl_filename)

      #app = "NewsController".constantize.action(action)
      #app.process params
      #app.response.body

      # result
      #c

      c.response.body
    end
  end
end
