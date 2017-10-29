module Optimacms
  module Appdata
    class Service

      def self.save(_env, content_name)

        Optimacms::Appdata::Service.run_rake_task("rake appdata:save  2>&1")
      end

      def self.update(_env, content_name)
        Optimacms::Appdata::Service.run_rake_task("rake appdata:update  2>&1")
      end


      ### ssh

      def self.save_by_ssh(_env, content_name)
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        storage = content['storage']

        #
        s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        ssh_opts = "-p #{storage['ssh_port']||22} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

        if storage['ssh_key'] && storage['ssh_key']!=''
          ssh_opts << " -i #{storage['ssh_key']}"
        end


        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)



          # create remote dir
          %x[ssh -t #{ssh_opts} #{s_ssh} mkdir -p #{d_remote}]

          # rsync
          cmd = %Q(rsync -Lavrt -e "ssh #{ssh_opts}" #{d_local_full} #{s_ssh}:#{d_remote} --delete)
          puts "#{cmd}"
          %x[#{cmd}]

        end
      end

      def self.update_by_ssh(_env, content_name)
        content = Optimacms::Appdata::Settings.get_content_info(_env, content_name)
        #puts "content: #{content}"
        storage = content['storage']

        #
        s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        ssh_opts = "-p #{storage['ssh_port']||22} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

        if storage['ssh_key'] && storage['ssh_key']!=''
          ssh_opts << " -i #{storage['ssh_key']}"
        end


        # sync dirs
        content['dirs'].each do |d|
          d_remote = File.join(storage['path'], d)+"/"
          d_local = File.join(File.dirname(d), File.basename(d))+"/"
          d_local_full = File.join(Rails.root, d_local)

          #
          %x[mkdir -p #{d_local_full}]

          # rsync
          cmd = %Q(rsync -Lavrt -e "ssh #{ssh_opts}" #{s_ssh}:#{d_remote} #{d_local_full} --delete)
          puts "#{cmd}"
          %x[#{cmd}]

        end
      end

      ###

      def self.build_git_cmd(cmd, _env)
        key_path = Settings.get_config_value('appdata_remote_repo_ssh_key', _env)


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

