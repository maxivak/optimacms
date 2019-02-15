module Optimacms
  module ContentBlock
    class Remote < Base

      attr_accessor :contents
      attr_accessor :remote_source_file_data


      def initialize( _source_name, _path, _options={})
        super   _source_name, _path, _options

        init_from_cache
      end


      def is_local?
        false
      end


      ##

      def get_remote_url(opts={})
        source.source_info[:api_url]+ path+"?"+opts.to_query
      end


      ##

      def get_file
        # download if needed
        if local_file.nil? || !local_file.exists?
          download_file
        end

        contents
      end


      def get_file_info
        download_file_info

      end

      ### source

      def source
        return @source unless @source.nil?

        @source = Optimacms::RemoteContent::ContentSourceBase.build_remote_source(source_name, options)
      end



      ### remote content

      def download_file
        @remote_source_file_data = source.get_file path, options

        return nil if @remote_source_file_data.nil?

        @contents = remote_source_file_data['content']

        # update local file
        local_file_basepath = build_local_file_basepath(remote_source_file_data['path'])

        local_file.update_basepath local_file_basepath
        #local_file.update_basepath remote_source_file_data['path']


        local_file.save_contents @contents

        # save to cache
        save_metadata_cache


        @contents
      end


      def download_file_info
        @remote_source_file_data = source.get_file path, options

        @remote_source_file_data
      end



      def get_contents
        # check cache
        if local_file.exists?
          return local_file.get_contents
        end

        # download
        download_file


        # return
        contents
      end


      ### local file

      def build_local_file_basepath(_source_path)
        if local_file_storage_type==STORAGE_TYPE_REMOTE_VIEWS
          return _source_path
        elsif local_file_storage_type==STORAGE_TYPE_REMOTE_BASIC
          s = build_hashstring(path+"--"+options.to_s)
          return s
        end

        raise 'storage type not supported'
      end


      ### metadata

      def init_from_cache

        # init basepath from cache
        file_meta = metadata_cache_file_path
        if File.exists? file_meta
          data = YAML.load_file file_meta

          if data
            v_local_basepath = data[:local_basepath]

            if v_local_basepath
              local_file.update_basepath v_local_basepath
            end

          end

        end


        true
      end



      def metadata_cache_file_path
        h = build_hashstring(path+"--"+options.to_s)

        f = File.join(Rails.root, Optimacms.config.remote_content_cache_dir, source_name, h+".meta.yml")

        f
      end

      def save_metadata_cache
        fpath = metadata_cache_file_path


        FileUtils.mkdir_p(File.dirname(fpath))

        data = {
            source: source_name,
            path: path,
            options: options.to_json,

            source_path: remote_source_file_data['path'],
            source_url: remote_source_file_data['source_url'],

            local_basepath: local_file.basepath

        }

        File.open(fpath,"w+") do |f|
          f.write data.to_yaml
        end

        true
      end



      ### remote file

      def remote_file_url
        remote_source_file_data['source_url']
      end


      ### utils

      def build_hashstring(s)
        require 'digest/sha1'
        Digest::SHA1.hexdigest s

      end


    end
  end

end