module Optimacms
  module PageServices
    # data used for processing page
    class PageData
      attr_accessor :page # page object
      #, :params
      attr_accessor :url, :url_vars
      attr_accessor :lang
      attr_accessor :controller, :action
      attr_accessor :layout
      attr_accessor :template

      attr_accessor :render_options
      attr_accessor :render_extra_options

      #
      attr_reader :compiled_view_path

      include PageProcessService

      def controller_class
        Object.const_get controller.to_s.camelize+'Controller'
      end

      def url_vars
        @url_vars || {}
      end

      def lang
        return @lang unless @lang.nil?

        # TODO: calc lang

        # from url
        lang_url = url_vars.fetch(:lang, '')

        return lang_url unless lang_url.blank?


        I18n.locale
      end

      def layout
        page.layout
      end

      def template
        page.template
      end

      def template_path
        if template.is_translated
          tpl_lang = self.lang
        else
          tpl_lang=''
        end
        page.template.path(tpl_lang)
      end

      def meta
        page_lang = page.is_translated ? lang : ''
        row = page.translations.where(:lang=>page_lang).first

        return nil if row.nil?

        {:title=>row.meta_title, :keywords=>row.meta_keywords, :description=>row.meta_description}
      end

      def view_content
        return '' if template.basepath.nil?

        f = template.fullpath
        return '' if !File.exists? f
        File.read(f)
      end

      def view_filename
        #Rails.root.to_s + '/app/views/'+view_path
        page.template.fullpath
      end

      def compiled_view_filename
        dir_cache+'/'+@compiled_view_basename
      end


      def compiled_view_path
        dirname_views+'/'+@compiled_view_basename
      end

      def dirname_views
        'optimacms/cache'
      end

      def dir_cache
        # TODO: get from settings
        Rails.root.to_s+'/app/views/'+dirname_views
      end


      def generate_content
        @compiled_view_basename = generate_view_name
        Optimacms::Fileutils::Fileutils::create_dir_if_not_exists compiled_view_filename

        text = compile_content view_content
        save_text_to_compiled_view text
      end

    end
  end
end
