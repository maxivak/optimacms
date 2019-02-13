module Optimacms
  module ContentBlock
    class LocalFileRemote < LocalFileBase
      #attr_accessor :hashstring, :basepath_with_hash
      attr_accessor :storage_type
      #attr_accessor :basepath_with_hash


      def initialize(_content_block, opts={})
        super _content_block, opts


        @storage_type = opts[:storage_type] || ContentBlock::Base::STORAGE_TYPE_REMOTE_BASIC

      end



      ### settings

      def dir_base
        if storage_type==ContentBlock::Base::STORAGE_TYPE_REMOTE_BASIC
          return File.join(Optimacms.config.remote_content_cache_dir,content_block.source_name)
        else
          return Optimacms.config.templates_remote_dir
        end

      end



      ## properties

      def path
        #f = basepath_with_hash
        f = basepath
        return nil if f.nil?

        #ff = basepath+"-"+hashstring
        File.join(dir_base, f)
      end


      def basepath_with_hash
        raise 'not used'
        f = basepath
        return nil if f.nil?


        return @basepath_with_hash unless @basepath_with_hash.nil?

        @basepath_with_hash = build_hashstring(content_block.path+"--"+content_block.options.to_s)

        @basepath_with_hash
      end

      def _old_basepath_with_hash
        f = basepath
        return nil if f.nil?


        return @basepath_with_hash unless @basepath_with_hash.nil?

        @basepath_with_hash = f.gsub(/^([^\.]+)\./, '\1'+'-'+hashstring+'.')

        @basepath_with_hash
      end


      def hashstring
        raise 'not used'
        return @hashstring unless @hashstring.nil?

        @hashstring = build_hashstring(content_block.options.to_s)
      end




      ### callbacks

      def after_update_basepath
        #@basepath_with_hash = nil

      end








    end
  end
end

