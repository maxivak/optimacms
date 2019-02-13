module Optimacms
  module RemoteContent
    class ContentSourceBase
      attr_accessor :source_name, :options, :source_info

      def initialize(source_name, opts={})
        @source_name = source_name
        @options = opts

      end

      def source_info
        return @source_info unless @source_info.nil?


        @source_name ||= Optimacms.config.default_content_source_name

        @source_info = Optimacms::RemoteContent::Sources.get_source_info(@source_name)

        @source_info
      end





      # should be overridden
      def get_file(path, opts={})
        raise 'not implemented'
      end


      ### builder

      def self.build_remote_source(source_name, options={})
        source_info = Optimacms::RemoteContent::Sources.get_source_info source_name

        raise 'source not found' if source_info.nil?

        # build by source class
        cls_source = nil
        if source_info[:class_source].is_a?(String)
          cls_source = Object::const_get(source_info[:class_source])
        else
          cls_source = source_info[:class_source]
        end

        if cls_source
          return cls_source.new(source_name, options)
        end


        # build with factory class
        cls_factory = nil
        if source_info[:class_factory].is_a?(String)
          cls_factory = Object::const_get(source_info[:class_factory])
        else
          cls_factory = source_info[:class_factory]
        end

        if cls_factory
          return cls_factory.build(source_name, options)
        end

        raise 'cannot create content source'
      end


    end
  end
end

