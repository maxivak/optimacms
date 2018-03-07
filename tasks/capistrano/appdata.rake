namespace :deploy do
namespace :appdata do
  require_relative '../../lib/optimacms/appdata/settings'


  task :check do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "appdata:check"
        end
      end
    end
  end

  task :setup do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "appdata:repo:setup_all"
        end
      end
    end
  end


  ###
=begin
  task :upload do
    # variant. upload using local cache of git repo
    d_repo = Optimacms::Appdata::Settings.appdata_repo_path(release_path, app_env)
    git_repo = Optimacms::Appdata::Settings.repo_app_site_data(app_env)

    # init local repo
    %x(mkdir -p #{d_repo})
    %x(cd #{d_repo} && git init)
    %x(cd #{d_repo} && git remote add origin #{git_repo})

    # pull
    %x(cd #{d_repo} && git pull origin master)

    # copy
    Optimacms::Appdata::Settings.site_app_data_dirs.each do |d|
      d_server_base = File.dirname(d)

      #puts "from #{d} to #{d_server_base}"
      #exit
      upload!(d+"/", "#{current_path}/"+d_server_base+"/", :recursive => true)
    end




  end
=end

  # variant1. upload directly to server
=begin
    on roles(:app) do
      AppSettings.site_app_data_dirs.each do |d|
        d_server_base = File.dirname(d)

        #puts "from #{d} to #{d_server_base}"
        #exit
        upload!(d+"/", "#{current_path}/"+d_server_base+"/", :recursive => true)
      end

      # commit to remote repo
      Rake::Task["deploy:appdata:server_save"].invoke

      #
      Rake::Task["deploy:restart"].invoke

    end
=end


  task :server_save do
    on roles(:app) do
      within release_path do
        #with fetch(:bundle_env_variables, {}) do
        with rails_env: fetch(:rails_env) do
          execute :rake, "appdata:save"
        end
      end
    end
  end


  task :server_update do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "appdata:update"
          #execute :bundle, 'exec', "rake appdata:update"
          #execute "cd #{release_path} && RAILS_ENV=#{e} bundle exec rake appdata:update"
          #execute "RAILS_ENV=#{e} rake appdata:update"
        end
      end
    end
  end




#### OLD
=begin
  task :server_save do
    on roles(:app) do
      p = File.join(shared_path, '..', 'repo-data')

      # rsync to repo-data
      #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' -e 'ssh -p {{ansible_ssh_port | default(22)}}'  {{root_user}}@{{inventory_hostname | quote}}:{{remote_path | quote}} {{backup_dir | quote }}
      #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' {{root_user}}@{{inventory_hostname}}:{{remote_path}} {{backup_dir}}


      # ok
      #execute "rsync -Lavrt --exclude-from '#{release_path}/.rsync_ignore' #{release_path}/ #{p}"

      # ok - app
      execute "rsync -Lavrt --exclude-from '#{release_path}/.rsync_ignore' #{release_path}/app/ #{p}/app"

      # commit & push to remote repo
      execute %Q(cd #{p} && git add . && git commit -m "server changes #{Time.now.utc}") rescue true
      execute %Q(cd #{p} && git push origin master) rescue true

      #git add -A .

    end
  end

  task :server_update do
    on roles(:web) do
      p = File.join(shared_path, '..', 'repo-data')
      execute %Q(cd #{p} && git pull origin master)
    end
  end

=end


end
end
