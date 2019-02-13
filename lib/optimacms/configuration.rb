module Optimacms
  class Configuration
    attr_accessor :yaml_config
    attr_accessor :files_dir_path,
                  :main_namespace, :admin_namespace,
                  :metadata

    # remote sources
    attr_accessor :content_sources,
                  :default_content_source_name,
                  :templates_remote_dir,
                  :default_templates_source_name,
                  :remote_content_cache_dir


    def initialize
      load_config

      @files_dir_path = @yaml_config['files_dir_path'] || 'uploads'
      @main_namespace = @yaml_config['main_namespace'] || ''
      @admin_namespace = @yaml_config['admin_namespace'] || 'admin'


      # metadata
      @metadata = @yaml_config['metadata']


      # content sources
      @content_sources ||= @yaml_config['content_sources'] || {}
      @default_content_source_name ||= @yaml_config['default_content_source'] || ''
      @default_templates_source_name ||= @yaml_config['default_templates_source_name'] || 'local'


    end


    def template_content_sources
      return @template_content_sources unless @template_content_sources.nil?

      @template_content_sources = @content_sources.select { |k, r| (r[:use_templates] || false) }.keys

    end



    ###

    def load_config
      @yaml_config = Rails.application.config_for(:optimacms)

      @yaml_config ||= {}
    end
  end
end