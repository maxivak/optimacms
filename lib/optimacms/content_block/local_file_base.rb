module Optimacms
  module ContentBlock
    class LocalFileBase

      attr_accessor :content_block
      attr_accessor :basepath


      def initialize(_content_block, opts={})
        @content_block = _content_block
      end


      def self.build(content_block, opts={})
        _storage_type = opts[:storage_type]
        cls = nil
        opts = {}
        if _storage_type == ContentBlock::Base::STORAGE_TYPE_VIEWS
          cls = LocalFileViews
        elsif _storage_type == ContentBlock::Base::STORAGE_TYPE_REMOTE_VIEWS || _storage_type == ContentBlock::Base::STORAGE_TYPE_REMOTE_BASIC
          cls = LocalFileRemote
          opts[:storage_type] = _storage_type
        end

        cls.new(content_block, opts)
      end

      def dir_base
        raise 'not implemented'
      end

      ###

      def options
        content_block.options
      end


      ### path properties

      def update_basepath(new_basepath)
        return if new_basepath.nil? || new_basepath==''

        #
        @basepath = new_basepath

        prepare_folders

        after_update_basepath

        @basepath
      end


      def after_update_basepath

      end

      def path
        f = basepath
        return nil if f.nil?

        File.join(dir_base, f)
      end

      def fullpath
        f = path
        return nil if f.nil?

        File.join(Rails.root, f)
      end


      ### content

      def get_contents
        File.read(fullpath)
      end


      def save_contents(_contents)
        File.open(fullpath, "w+") do |f|
          f.write(_contents)
        end

        true
      end


      ###
      def exists?
        #FileUtils.mkdir_p(File.dirname(f))

        f = fullpath
        return false if f.nil?


        if File.exists?(f)
          return true
        end

        false
      end


      ### utils

      def prepare_folders
        FileUtils.mkdir_p(File.dirname(fullpath))
      end



      def build_hashstring(s)
        require 'digest/sha1'
        Digest::SHA1.hexdigest s

      end

    end
  end
end

