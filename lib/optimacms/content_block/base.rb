module Optimacms
  module ContentBlock
    class Base
      STORAGE_TYPE_VIEWS = 'views'
      STORAGE_TYPE_REMOTE_VIEWS = 'views_remote'
      STORAGE_TYPE_REMOTE_BASIC = 'basic'

      attr_accessor :source_name, :path, :options,
                    :source


      attr_accessor :local_file_storage_type
      #attr_accessor :local_file_basepath
      attr_accessor :local_file


      def initialize(_source_name, _path, _options={})
        @source_name = _source_name
        @path = _path
        @options = _options

        @local_file_storage_type = _options[:storage_type] || STORAGE_TYPE_VIEWS

        if @local_file_storage_type
          @local_file = LocalFileBase.build self, {storage_type: @local_file_storage_type}
        end


      end




      ###

      # should be implemented in a derived class
      def get_file
        raise 'not implemented'
      end


      def get_file_info
        raise 'not implemented'
      end


      ### contents

      def get_contents
        raise 'not implemented'
      end


      ## properties

      def is_local?
        raise 'not implemented'
      end



    end
  end

end