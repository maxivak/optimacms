module Optimacms
  module Deploy

  class Settings

  def self.settings
    return @config if @config

    # load from yaml
    @config = YAML.load_file(filename_config)
    @config
  end

  def self.filename_config
    File.join(Rails.root, 'config/appdata', 'appdata.yml')
  end



  def self.deploy_dirs_exclude(_env)
    a1 = get_config_value('site_user_data_dirs', _env, [])
    a2 = get_config_value('site_app_data_dirs', _env, [])

    a1+a2
  end

  def self.appdata_repo_path(_env)
    e = _env
    dir_base_path = get_config_value("appdata_local_repo_dir", e)

    if dir_base_path[0]=='/'
      d_repo = File.join(dir_base_path)
    else
      d_repo = File.join(Rails.root, dir_base_path)
    end

  end





  def self.get_config_value(name, _env, v_def=nil)
    e = _env
    e = 'default' unless e

    v = settings[e][name.to_s] || settings['default'][name.to_s] || settings[name] || v_def

    v
  end


  ###
  def self.method_missing(m, *args, &block)
    v = get_config_value(m.to_s, args[0])
    v
  end

end
end
end
