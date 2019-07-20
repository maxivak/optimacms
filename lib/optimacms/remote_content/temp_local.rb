module Optimacms
  module ContentBlock
    class Local < Base


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

