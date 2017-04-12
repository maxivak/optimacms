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

          return render_base(options, extra_options, &block)

          #"gell"
        end
      end

    end
  end
end

