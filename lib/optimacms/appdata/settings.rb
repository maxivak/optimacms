module Optimacms
  module Appdata

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


  def self.list_content(_env)
    list = get_config_value("content", _env)

    list
  end

  def self.get_content_info(_env, name)
    list = get_config_value("content", _env)

    res = nil
    list.each do |v|
      if v['name']==name
        res = v
        break
      end

    end

    res
  end


  def self.storage_repo_local_path(storage)
    #e = _env
    #dir_base_path = get_config_value("appdata_local_repo_dir", e)
    d = storage['local_repo_dir']

    if d[0]=='/'
      d_repo = File.join(d)
    else
      d_repo = File.join(Rails.root, d)
    end

    d_repo
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
