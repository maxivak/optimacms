module Optimacms
  module Renderer
    module AdminPageRenderer
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def renderer_admin_edit
          include Optimacms::Renderer::AdminPageRenderer::InstanceMethods
        end
      end

      module InstanceMethods
        def render_with_edit(options = nil, extra_options = {}, &block)

          #return render_base(options, extra_options, &block)

          #s = render_to_string(options, extra_options, &block)

          #
          #@__page_tpl = @pagedata.template
          #@__page_tpl_name = options || extra_options[:template]
          @pagedata.render_options = options
          @pagedata.render_extra_options = extra_options


          # template

          #@__page_tpl = Optimacms::PageServices::TemplateService.get_by_name(@__page_tpl_name)

          # data relations
          @__page_tpl_data_relations = (@pagedata.template.data_relations.all.index_by { |t| t.var_name } rescue [])


          #
          render_base 'optimacms/admin_page_edit/page', extra_options, &block
        end
      end

    end
  end
end

