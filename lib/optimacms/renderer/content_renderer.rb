module Optimacms
  module Renderer
    class ContentRenderer
      attr_accessor :context, :pagedata

      def initialize(_ctx, _pagedata)
        @context = _ctx
        @pagedata = _pagedata
      end


      ### interface methods

      def do_render_page(options = nil, extra_options = {}, &block)
        options ||= {} # initialise to empty hash if no options specified

        if !context.current_cms_admin_user
          return context.render_base(options, extra_options, &block)
        end

        # special cases

        # render text
        if options.is_a?(Hash) && options[:text]
          return context.render_base(options, extra_options, &block)
        end


        # base version
        #render_base(options, extra_options, &block)

        # editor for admin
        context.render_with_edit(options, extra_options, &block)
      end


      # content page without custom controller
      def render_page_content

        #@content = @pagedata.get_content(@page)
        #@content = @page.content


        #controller.optimacms_set_pagedata pagedata

        #my_set_render_template @pagedata.template_path, @pagedata.layout.basename
        #context.my_set_render_layout pagedata.layout.basename
        #context.my_set_meta pagedata.meta



        #optimacms_tpl = pagedata.page_template.basepath
        #context.my_set_render_template optimacms_tpl

        #context.render "/"+@optimacms_tpl, :layout=>@optimacms_layout
        do_render_page "/"+pagedata.template, :layout=>pagedata.layout


        # v1
        #render @optimacms_tpl, :layout=>@optimacms_layout


        # v2
        #render :text => @content, :layout => @page.layout.name

        # v3
        #cont = ApplicationController.render(
        #    template: ff,
        #    assigns: { user: @user }
        #)

        #render_base inline: cont

=begin
        # v4
        respond_to do |format|
          format.html { render :text => @content }
        end
        return
=end

        return

      end



      def render_block(source_name, path, block_options={})
        options = build_options block_options
        block_path = build_block_path path, block_options

        content_block = Optimacms::ContentBlock::Factory.for_source_in_views source_name, block_path, options

        return render_content_block content_block
      end


      def render_rblock(source_name, path, block_options={})
        options = build_options block_options
        block_path = build_block_path path, block_options

        content_block = Optimacms::ContentBlock::Factory.for_remote source_name, block_path, options

        return render_content_block content_block
      end



      ### main method to render block
      def render_content_block(content_block)

        # init file
        content_block.get_file

        #@context.render file: content_block.local_file_basepath, locals: options


        f = content_block.local_file.path

        # render from file
        if File.exists? f
          #opts[:file] = f
          #return render opts

          if @context.current_cms_admin_user
            #return block_with_edit file: f, locals: options
            #return @context.block_with_edit content_block.path, f, content_block.options
            return render_block_with_edit content_block
          else
            return @context.render file: f, locals: content_block.options
          end

        end


        # default render
        @context.render f, content_block.options

      end



      ###

      def render_block_with_edit(content_block, _opts={})
        #tpl_filename = content_block.path
        tpl_filename = content_block.local_file.path
        opts = content_block.options

        # TODO: change it

        # find template
        #row_tpl = Optimacms::PageServices::TemplateService.get_by_name(block_path)
        #links_edit = Optimacms::PageServices::TemplateService.get_links_edit(row_tpl)

        row_tpl = nil
        links_edit = []


        # render
        opts.merge!({optimacms_filename: tpl_filename, optimacms_tpl: row_tpl})
        opts[:optimacms_admin_links_edit] = links_edit

        return (context.render template: 'optimacms/admin_page_edit/block_edit', :locals => opts)

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



      ### helpers

      def build_block_path(path, options={})
        block_path = path

        # respect current dir
        if path =~ /^[^\/]+$/
          current_template_dir = File.dirname pagedata.template
          if current_template_dir!='' && current_template_dir!='.'
            block_path = File.join current_template_dir, path
          end
        end

        block_path
      end

      def build_options(block_options={})
        options = block_options.clone

        options[:lang] ||= pagedata.lang

        options
      end




    end

  end
end
