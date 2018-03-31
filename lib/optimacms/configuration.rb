module Optimacms
  class Configuration
    attr_accessor :yaml_config
    attr_accessor :files_dir_path,
                  :main_namespace, :admin_namespace,
                  :metadata


    def initialize
      load_config

      @files_dir_path = @yaml_config['files_dir_path'] || 'uploads'
      @main_namespace = @yaml_config['main_namespace'] || ''
      @admin_namespace = @yaml_config['admin_namespace'] || 'admin'

      # metadata
      @metadata = @yaml_config['metadata']
    end

    def load_config
      @yaml_config = Rails.application.config_for(:optimacms)

      @yaml_config ||= {}
    end
  end
end