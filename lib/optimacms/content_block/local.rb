module Optimacms
  module ContentBlock
    class Local < Base

      def initialize( _source_name, _path, _options={})
        super   _source_name, _path, _options

        #init
      end


      def is_local?
        true
      end

      def get_file
        # init if needed
        if local_file.nil? || !local_file.exists?
          init_local_file

        end

        if !local_file.exists?
          raise 'file not found'
        end


        #get_contents
      end

      def get_file_info
        # do nothing
      end


      def get_contents
        if local_file.exists?
          return local_file.get_contents
        end

        #raise 'not found'
        nil
      end


      ###

      def dir_base
        'app/views'
      end


      def init_local_file
        local_file_basepath = nil

        name = path
        lang = options[:lang]


        # find template by path

        template = Optimacms::PageServices::TemplateService.get_by_name(path)

        if template
          if template.is_translated?
            local_file_basepath = template.path(lang)
          else
            local_file_basepath = template.path(nil)
          end


        else
          # find file on disk
          f_opts = {}
          f_opts[:lang] = lang

          page_template_path = options[:page_template_path]
          if page_template_path
            d = File.dirname(options[:page_template_path]) # OK 2019-jan
          else
            d=''
          end

          f_opts[:current_dir] = d

          local_file_basepath = PageServices::TemplateService.get_file_for_path(path, f_opts)

        end


        # set
        if local_file_basepath
          local_file.update_basepath local_file_basepath
        end


        true
      end


    end
  end
end

