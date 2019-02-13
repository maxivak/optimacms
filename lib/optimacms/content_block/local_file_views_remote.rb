module Optimacms
  module ContentBlock
    class LocalFileViewsRemote < LocalFileBase

      def initialize(_content_block)
        super _content_block

      end



      ### settings

      def dir_base
        Optimacms.config.templates_remote_dir
      end


      ### path

      def path
        f = basepath
        return nil if f.nil?

        File.join(dir_base, f)
      end






    end
  end
end

