module Optimacms
  module RemoteContent
    class Sources

      def self.get_source_info(source_name)
        Optimacms.config.content_sources[source_name]
      end
    end
  end
end

