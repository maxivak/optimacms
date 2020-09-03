module Optimacms::PageServices
    # data used for processing page
    class PageData
      attr_accessor :page # page object
      #, :params
      attr_accessor :url, :url_vars
      attr_accessor :lang
      attr_accessor :controller, :action
      #attr_accessor :layout
      #attr_accessor :template
      #attr_accessor :template_source
      attr_accessor :render_options
      attr_accessor :render_extra_options

      attr_reader :compiled_view_path

      #include Optimacms::PageServices::PageProcessService

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

      ### rendering data
      def page_template
        #page.template
        return @page_template unless @page_template.nil?

        source_name = page.template_source_name
        path = page.template_path
        source_info = ::Friendlycontent::Rails.config.get_source_info(source_name)

        # build options for template
        s_template_options = page.template_options || "{}"
        s_template_options = "{}" if s_template_options==''
        template_options = eval(s_template_options, template_options_binding)

        ::Friendlycontent::ContentBlock::Factory.create(source_info, path, template_options)
      end

      def template_options_binding
        self.url_vars.each_pair do |k,v|
          key = k.to_s
          eval('key = v')
        end

        binding
      end

      def template
        page_template.local_file.basepath
      end

      def template_virtual_path
        page_template.path
      end

      def layout
        page.layout.basename
      end

      def template_source
        page_template.source_name
      end

      ### meta
      def meta
        page_lang = page.is_translated ? lang : ''
        row = page.translations.where(:lang=>page_lang).first

        return nil if row.nil?

        {:title=>row.meta_title, :keywords=>row.meta_keywords, :description=>row.meta_description}
      end



      ### view
=begin
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
        raise 'not used'
        # TODO: get from settings
        Rails.root.to_s+'/app/views/'+dirname_views
      end


      def generate_content
        @compiled_view_basename = generate_view_name
        Optimacms::Fileutils::Fileutils::create_dir_if_not_exists compiled_view_filename

        text = compile_content view_content
        save_text_to_compiled_view text
      end
=end

    end
end
