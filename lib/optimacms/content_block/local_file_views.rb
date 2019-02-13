module Optimacms
  module ContentBlock
    class LocalFileViews < LocalFileBase

      def initialize(_content_block, opts={})
        super _content_block, opts

        init

      end

      def dir_base
        'app/views'
      end

      def init


      end



    end
  end
end

