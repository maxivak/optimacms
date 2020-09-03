module Optimacms
  module Renderer
    class Renderer
      attr_accessor :context, :render_options

      def initialize(_ctx, opts={})
        @context = _ctx
        @render_options = opts
      end

      # content page without custom controller
      def render_page(pagedata, options = nil, extra_options = {}, &block)
        #context.render "/"+@optimacms_tpl, :layout=>@optimacms_layout
        virtual_path = "/"+pagedata.template_virtual_path
        options = {layout: pagedata.layout}

        context.instance_variable_set('@virtual_path', pagedata.template_virtual_path)

        # editor for admin
        is_admin_edit = render_options[:is_admin_edit] || false
        if is_admin_edit
          # changed 2020-mar.
          #raise "Not supported while admin is logged in. Log out from admin area."
          #return render_with_edit(pagedata, options, extra_options, &block)
        end

        # render text
        #if options.is_a?(Hash) && options[:text]
        #  return context.render(virtual_path, options, &block)
        #end

        # base version
        render_base(virtual_path, options, &block)

        # v3
        #cont = ApplicationController.render(
        #    template: ff,
        #    assigns: { user: @user }
        #)

      end

      def render_base(options = nil, extra_options = {}, &block)
        function_default_render = render_options[:function_default_render]

        if function_default_render.nil?
          return context.render(options, extra_options, &block)
        else
          return context.send(function_default_render, options, extra_options, &block)
        end
      end

      def render_with_edit(pagedata, options = nil, extra_options = {}, &block)
        #return render_base(options, extra_options, &block)
        #s = render_to_string(options, extra_options, &block)

        # TODO: why we need this???
        #@pagedata.render_options = options
        #@pagedata.render_extra_options = extra_options

        # template
        #@__page_tpl = Optimacms::PageServices::TemplateService.get_by_name(@__page_tpl_name)

        # data relations
        #@__page_tpl_data_relations = (pagedata.template.data_relations.all.index_by { |t| t.var_name } rescue [])
        page_tpl_data_relations = (pagedata.template.data_relations.all.index_by { |t| t.var_name } rescue [])
        context.instance_variable_set("@__page_tpl_data_relations", page_tpl_data_relations)

        render_base 'optimacms/admin_page_edit/page', options, &block
      end

      ### main method to render block
      def render_content_block(content_block)
        # init file, download if needed
        content_block.get_file
        f = content_block.local_file.path

        # render from file
        if File.exists? f
          #opts[:file] = f
          #return render opts

          if context.current_cms_admin_user
            #return block_with_edit file: f, locals: options
            #return @context.block_with_edit content_block.path, f, content_block.options
            return render_block_with_edit content_block
          else
            return context.render file: f, locals: content_block.options
          end
        end

        # default render
        render_base f, content_block.options
      end

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

        if pagedata
          options[:lang] ||= pagedata.lang
        end


        options
      end




      ### assets

      def get_file_url(source_name, path, block_options={})
        options = build_options block_options
        #block_path = build_block_path path, block_options
        block_path = path

        content_block = Optimacms::ContentBlock::Factory.for_remote source_name, block_path, options

        content_block.get_remote_url({format: "raw"})

      end

    end
  end
end
