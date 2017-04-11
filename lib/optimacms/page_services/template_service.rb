module Optimacms
  module PageServices
    class TemplateService

      def self.get_by_name(name)
        row = Template.where(basepath: name).first

        row
      end
    end
  end
end

