#require_dependency "../../lib/optimacms/page_services/page_route_service.rb"
#require_dependency "../../lib/optimacms/page_services/page_process_service.rb"

require_dependency "../../lib/optimacms/renderer/admin_page_renderer.rb"

module Optimacms

  class PagesController < Optimacms::ApplicationController
    include Optimacms::Mycontroller

    # render
    unless respond_to?(:render_base)
      alias_method :render_base, :render
    end


    include Optimacms::Renderer::AdminPageRenderer

    renderer_admin_edit

    def render(options = nil, extra_options = {}, &block)
      options ||= {} # initialise to empty hash if no options specified

      if !current_cms_admin_user
        return render_base(options, extra_options, &block)
      end

      # special cases
      if options.is_a?(Hash) && options[:text]
        return render_base(options, extra_options, &block)
      end



      # editor for admin
      #render_base(options, extra_options, &block)

      render_with_edit(options, extra_options, &block)
    end



=begin
    def my_set_render_template(tpl_view, tpl_layout)
      @optimacms_tpl = tpl_view
      @optimacms_layout = tpl_layout
    end

    def my_set_meta(meta)
      #@optimacms_meta = meta
      @optimacms_meta_title = meta[:title]
      @optimacms_meta_keywords = meta[:keywords]
      @optimacms_meta_description = meta[:description]
    end
=end

    def renderActionInOtherController(controller,action,params, tpl_view=nil, tpl_layout=nil)

      # include render into controller class
      if current_cms_admin_user
        controller.send 'include', Optimacms::Renderer::AdminPageRenderer
        controller.send 'renderer_admin_edit'
      end



      #
      c = controller.new
      c.params = params

      if current_cms_admin_user
        #if !controller.respond_to?(:render_base, true)
        if !c.respond_to?(:render_base, true)
          controller.send :alias_method, :render_base, :render

          controller.send :define_method, "render" do |options = nil, extra_options = {}, &block|
            if current_cms_admin_user && @pagedata
              render_with_edit(options, extra_options, &block)
            else
              render_base(options, extra_options, &block)
            end

          end
        end
      end


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
      c.send 'my_set_render_template', tpl_view, tpl_layout
      c.send 'my_set_meta', @pagedata.meta



      #renderer_admin_edit

      #c.process_action(action)
      c.dispatch(action, request, c.response)
      #c.process_action(action, tpl_filename)

      #app = "NewsController".constantize.action(action)
      #app.process params

      # result
      #c

      c.response.body

      #app.response.body
    end


    def show
      @path = params[:url]
      @pagedata = PageServices::PageRouteService.find_page_by_url(@path, current_lang)

      if @pagedata.page.nil?
        not_found and return
      end

      # page mapped to controller
      @pagedata.url_vars.each do |k,v|
        params[k] = v
      end



      # process page
      if @pagedata.page.content_page?
        # content page
        #@content = @pagedata.get_content(@page)
        #@content = @page.content

        optimacms_set_pagedata @pagedata
        my_set_render_template @pagedata.template_path, @pagedata.layout.basename
        my_set_meta @pagedata.meta

        # callbacks from main app
        if respond_to?(:before_page_render)
          send(:before_page_render)
        end

        render @optimacms_tpl, :layout=>@optimacms_layout
        #render :text => @content, :layout => @page.layout.name
        return
        respond_to do |format|
          format.html { render :text => @content }
        end
        return
      else
        #@pagedata.generate_content

        #
        #c = renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params, @pagedata.compiled_view_path, @pagedata.layout.basename)
        c = renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params, @pagedata.template_path, @pagedata.layout.basename)

        render text: c

        return
=begin
        # THE END

        s = <<-eos
From code
<p>News on page</p>

<p>page = <%=@pg%></p>

<p>hello</p>

<p>&nbsp;</p>

<p>local page = <%=@pg%></p>

news count = <%=News.all.count%>
<br>
render<br>
<%=render 'pages/sub.html.erb'%>

        eos

        #s = File.read(Rails.root+'app/views/pages/news2.html.erb')

        # save template content
        tpl_view = 'pages/1.html.erb'
        fnew = Rails.root+'app/views/'+tpl_view
        File.open(fnew, "w+") do |f|
          f.write(s)
        end



        #
        template = ERB.new(s, 0, "%<>")

        #vv = OpenStruct.new(pg: 75, last: 'Maragall')
        #vv = OpenStruct.new(c.instance_values)
        #ss = template.result(vv.instance_eval { binding })
        #ss = template.result(c.instance_values.instance_eval { binding })
        #ss = template.result(c.get_binding)
        #ss = template.result(c.instance_values.binding())

        #render :text=>ss
        #render :text=>c

        vars = {}
        c.instance_values.each do |k,v|
          vars[k.to_sym] = v
        end

        #render template: 'pages/1.html.erb', locals: vars

        #render template: 'pages/news2.html.erb', locals: {pg: 4}
        #render text: s, locals: {pg: 4}

        #render :text => (render_to_string :template=>'pages/news2.html', :locals=> {pg: 4})
        #render :text => (render_to_string 'pages/news2.html', locals: c.instance_values)
        #render :text => renderActionInOtherController(@pagedata.controller_class, @pagedata.action, params)
=end


      end

    end

    ### page URLs


  end
end
