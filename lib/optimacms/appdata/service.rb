module Optimacms
  module Appdata
    class Service

      def self.setup(_env, content_name)
        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)

        # storage
        setup_storage content


      end

      def self.save(_env, content_name)
        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        if storage['type']=='git'
          return save_by_git(_env, content_name)
        elsif storage['type']=='ssh'
          return save_by_ssh(_env, content_name)
        elsif storage['type']=='local'
          return save_by_local(_env, content_name)
        end

        return nil
      end

      def self.update(_env, content_name)
        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        if storage['type']=='git'
          return update_by_git(_env, content_name)
        elsif storage['type']=='ssh'
          return update_by_ssh(_env, content_name)
        elsif storage['type']=='local'
          return update_by_local(_env, content_name)
        end


        #Optimacms::Appdata::Service.run_rake_task("rake appdata:update  2>&1")
      end


      ###
      def self.setup_storage(content)
        # storage
        storage = content['storage']

        if storage['type']=='git'
          return setup_git_storage(storage)
        elsif storage['type']=='ssh'
        elsif storage['type']=='local'
        end

        return nil
      end

      ### local storage

      def self.save_by_local(_env, content_name)
        #
        res_output = []

        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)



          # create remote dir
          %x[mkdir -p #{d_remote}]

          # rsync
          cmd = %Q(rsync -Lavrt #{d_local_full} #{d_remote} --delete)
          puts "#{cmd}"
          %x[#{cmd}]

        end

        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}

      end

      def self.update_by_local(_env, content_name)
        #
        res_output = []

        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)+"/"
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)

          #
          %x[mkdir -p #{d_local_full}]

          # rsync
          cmd = %Q(rsync -Lavrt #{d_remote} #{d_local_full} --delete)
          puts "#{cmd}"
          %x[#{cmd}]

        end

        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}
      end



      ### ssh

      def self.save_by_ssh(_env, content_name)
        #
        res_output = []

        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        cmd = SshCommand.new
        ssh_options = {
            port: storage['ssh_port'],
            user: storage['ssh_user'],
            password: storage['ssh_password'],
            key: storage['ssh_key']
        }

        #s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        #ssh_opts = "-p #{storage['ssh_port']||22} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
        #if storage['ssh_key'] && storage['ssh_key']!=''
        #  ssh_opts << " -i #{storage['ssh_key']}"
        #end

        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)



          # create remote dir
          #%x[ssh -t #{ssh_opts} #{s_ssh} mkdir -p #{d_remote}]
          cmd_create = %Q(mkdir -p #{d_remote})
          res_cmd_create = cmd.run_ssh_cmd(storage['host'], ssh_options, cmd_create)

          if res_cmd_create[:res]!=1
            raise "Cannot create dir: #{res_cmd_create[:error]}"
          end


          # rsync
          cmd_rsync = RsyncCommand.build_cmd_with_ssh_save(storage, d_local_full, d_remote)
          #puts "#{cmd_rsync}"
          output = %x[#{cmd_rsync}]

        end

        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}

      end

      def self.update_by_ssh(_env, content_name)
        #
        res_output = []

        #
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        #s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        #ssh_opts = "-p #{storage['ssh_port']||22} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
        #if storage['ssh_key'] && storage['ssh_key']!=''
        #  ssh_opts << " -i #{storage['ssh_key']}"
        #end


        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)+"/"
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)

          # create local dir
          %x[mkdir -p #{d_local_full}]


          # rsync
          cmd_rsync = RsyncCommand.build_cmd_with_ssh_update(storage, d_local_full, d_remote)
          #puts "#{cmd_rsync}"
          output = %x[#{cmd_rsync}]

          #cmd = %Q(rsync -Lavrt -e "ssh #{ssh_opts}" #{s_ssh}:#{d_remote} #{d_local_full} --delete)

        end

        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}
      end



      ###

      def self.save_by_git(_env, content_name)
        res_output =[]

        # input
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        # setup
        setup_git_storage storage

        # update repo first
        git_pull(_env, content_name)

        #
        repo_local_path = Optimacms::Appdata::Settings.storage_repo_local_path(storage)


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

        content['dirs'].each do |d|
          d_from = File.join(Rails.root, d)
          d_to = File.join(repo_local_path, d)
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
        git_commit_push(_env, content_name)


        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}
      end



      def self.update_by_git(_env, content_name)
        res_output = []

        # input
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']


        # update repo first
        git_pull _env, content_name

        # copy to project
        repo_local_path = Optimacms::Appdata::Settings.storage_repo_local_path(storage)

        content['dirs'].each do |d|
          d_from = File.join(repo_local_path, d)
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

        #
        {res: true, output: res_output.join("; ")}

      rescue => e
        {res: false, output: "#{e.message}, #{e.backtrace.join(",")}"}
      end



      ### git helpers

      def self.content_setup_git(_env, content_name)
        # input
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        setup_git_storage(storage)

      end

      def self.setup_git_storage(storage)
        repo_local_path = Optimacms::Appdata::Settings.storage_repo_local_path(storage)

        #
        FileUtils.mkdir_p(repo_local_path) unless File.directory?(repo_local_path)


        # init local git repo
        repo_url = storage['remote_repo']

        # run commands
        %x[cd #{repo_local_path} && git init ]
        %x[cd #{repo_local_path} && git remote add origin  #{repo_url} ] rescue nil
        %x[cd #{repo_local_path} && git remote set-url origin  #{repo_url} ]
      end


      def self.git_pull(_env, content_name)
        # input
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']


        # init repo
        #Rake::Task["appdata:repo:setup"].invoke


        #
        repo_local_path = Optimacms::Appdata::Settings.storage_repo_local_path(storage)
        git_cmd = build_git_cmd(storage, 'git pull origin master')

        cmd = %Q(cd #{repo_local_path} && #{git_cmd})
        puts "#{cmd}"
        %x[#{cmd}]
      end



      def self.git_commit_push(_env, content_name)
        # input
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']


        #
        repo_local_path = Optimacms::Appdata::Settings.storage_repo_local_path(storage)


        # commit & push to remote repo
        %x[cd #{repo_local_path} && git add . && git commit -m "server changes #{Time.now.utc}" ] rescue true

        #
        git_cmd = build_git_cmd(storage, 'git push origin master')

        %x[cd #{repo_local_path} && #{git_cmd}] rescue true

        #git add -A .
      end



      ### helpers

      def self.build_git_cmd(storage, cmd)
        key_path = storage['remote_repo_ssh_key']


        #ssh
        if key_path && key_path!=''
          res= %Q(GIT_SSH_COMMAND='ssh -i #{key_path} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' #{cmd})
        else
          res = %Q(#{cmd})
        end

        res
      end


      def self.run_rake_task(cmd)
        cmd = %Q(#{cmd})
        puts "cmd: #{cmd}"
        res_output = %x[#{cmd}]
        exit_code = $?.exitstatus

        #output = "exit_code = #{exit_code}; message: #{res_output}"

        # res
        {res: (exit_code==0), output: res_output, exit_code: exit_code}
      end
    end
  end
end

