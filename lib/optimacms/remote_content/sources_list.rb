module Optimacms
  module RemoteContent
    class SourcesList

      attr_accessor :items


      def items
        Optimacms.config.content_sources
      end


      def settings(name)
        data[name]
      end

    end
  end
end