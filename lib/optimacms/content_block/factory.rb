module Optimacms
  module ContentBlock
    class Factory


      ### for page
      def self.for_page(page, options={})
        source_name = page.template_source_name
        path = page.template_path

        return for_source_in_views(source_name, path, options)
      end


      ### for block
      def self.for_source_in_views(source_name, path, options={})
        source_info = Optimacms::RemoteContent::Sources.get_source_info(source_name)

        block_options = options.clone

        if source_info[:type]=='local'
          block_options[:storage_type] = Base::STORAGE_TYPE_VIEWS
          obj = Local.new( source_name, path, block_options)
        elsif source_info[:type]=='remote'
          block_options[:storage_type] = Base::STORAGE_TYPE_REMOTE_VIEWS
          obj = Remote.new( source_name, path, block_options)

        end

        obj
      end

      def self.for_local(source_name, path, options={})
        options[:storage_type] = Base::STORAGE_TYPE_VIEWS
        obj = Local.new( source_name, path, options)
      end


      def self.for_remote(source_name, path, options={})
        options[:storage_type] = Base::STORAGE_TYPE_REMOTE_BASIC
        obj = Remote.new( source_name, path, options)
      end


      def self.for_remote_in_views(source_name, path, options={})
        options[:storage_type] = Base::STORAGE_TYPE_REMOTE_VIEWS
        obj = Remote.new( source_name, path, options)
      end


    end
  end
end

