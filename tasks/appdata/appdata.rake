# sync
namespace :appdata do
  require_relative '../lib/../../lib/optimacms/deploy/settings'

  task :check => :environment do
    e = Rails.env
    puts "RAILS_ENV=#{e}"

  end

  # get from remote repo and copy to the project/application
  task :update => :environment do
    # init repo
    Rake::Task["appdata:repo:setup"].invoke


    # update repo first
    Rake::Task["appdata:repo:pull"].invoke

    # copy to project
    d_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)

    Optimacms::Deploy::Settings.site_app_data_dirs(Rails.env).each do |d|
      d_from = File.join(d_repo, d)

      d_to = File.join(Rails.root, d)
      d_to_base = File.dirname(d_to)

      puts "copy from #{d_from} to #{d_to}"
      #in #{d_to_parent}

      FileUtils.mkdir_p d_to

      # copy dir
      FileUtils.cp_r d_from, d_to_base
      #FileUtils.copy_entry d_from, d_to_parent
      #FileUtils.cp_r d_from, Rails.root
    end


  end

  # save current data to remote repo
  task :save => :environment do
    # init repo
    Rake::Task["appdata:repo:setup"].invoke

    # update repo first
    Rake::Task["appdata:repo:pull"].invoke

    #
    d_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)


    # rsync to repo-data
    #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' -e 'ssh -p {{ansible_ssh_port | default(22)}}'  {{root_user}}@{{inventory_hostname | quote}}:{{remote_path | quote}} {{backup_dir | quote }}
    #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' {{root_user}}@{{inventory_hostname}}:{{remote_path}} {{backup_dir}}


    # ok
    #execute "rsync -Lavrt --exclude-from '#{release_path}/.rsync_ignore' #{release_path}/ #{p}"

    # ok - app
    #execute "rsync -Lavrt --exclude-from '#{release_path}/.rsync_ignore' #{release_path}/app/ #{p}/app"
    #%x[rsync -Lavrt --exclude-from '#{d}/.rsync_ignore' #{d}/ #{p}/ ]

    # check if rsync available
    output = %x(which rsync)
    res_rsync = output.strip.delete(" \t\r\n")

    Optimacms::Deploy::Settings.site_app_data_dirs(Rails.env).each do |d|
      d_from = File.join(Rails.root, d)

      d_to = File.join(d_repo, d)
      d_to_base = File.dirname(d_to)

      puts "copy from #{d_from} to #{d_to}"

      FileUtils.mkdir_p d_to

      # rsync or copy
      if res_rsync!=""
        cmd = %Q(rsync -Lavrt #{d_from}/ #{d_to}/)
        puts "#{cmd}"
        %x(#{cmd})
      else
        # no rsync
        puts "no rsync. copying..."

        FileUtils.cp_r d_from, d_to_base
      end
    end



    # repo
    Rake::Task["appdata:repo:commit_push"].invoke


  end


  ### operations with repo

  namespace :repo do
    task :setup => :environment do
      d_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)

      #
      FileUtils.mkdir_p(d_repo) unless File.directory?(d_repo)

      # init local git repo
      repo_url = Optimacms::Deploy::Settings.appdata_remote_repo(Rails.env)

      %x[cd #{d_repo} && git init ]
      %x[cd #{d_repo} && git remote add origin  #{repo_url} ] rescue nil
      %x[cd #{d_repo} && git remote set-url origin  #{repo_url} ]

    end


    task :pull => :environment do
      # init repo
      Rake::Task["appdata:repo:setup"].invoke


      #
      d_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)
      git_cmd = Optimacms::Deploy::Service.build_git_cmd('git pull origin master', Rails.env)

      puts "cd #{d_repo} && #{git_cmd}"
      %x[cd #{d_repo} && #{git_cmd}]
    end

    task :commit_push => :environment do
      #
      d_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)

      # commit & push to remote repo
      %x[cd #{d_repo} && git add . && git commit -m "server changes #{Time.now.utc}" ] rescue true

      #
      git_cmd = Optimacms::Deploy::Service.build_git_cmd('git push origin master', Rails.env)

      %x[cd #{d_repo} && #{git_cmd}] rescue true

      #git add -A .
    end
  end



end
