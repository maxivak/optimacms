module Optimacms
  module Deploy
    class Service

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

