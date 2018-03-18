module Optimacms
  module Appdata
    class RsyncCommand


      def self.build_cmd_with_ssh_save(storage, d_local_full, d_remote)
        s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        ssh_opts = build_ssh_opts(storage)

        cmd_rsync = %Q(rsync -Lavrt -e "ssh #{ssh_opts}" #{d_local_full} #{s_ssh}:#{d_remote} --delete)

        cmd = nil
        if storage['ssh_key'] && storage['ssh_key']!=''
          # use ssh key
          cmd = cmd_rsync
        else
          # use sshpass with password
          cmd = %Q(sshpass -p #{storage['ssh_password']} #{cmd_rsync})
        end


        cmd
      end

      def self.build_cmd_with_ssh_update(storage, d_local_full, d_remote)
        s_ssh = " #{storage['ssh_user']}@#{storage['host']}"
        ssh_opts = build_ssh_opts(storage)

        cmd_rsync = %Q(rsync -Lavrt -e "ssh #{ssh_opts}" #{s_ssh}:#{d_remote} #{d_local_full} --delete)


        cmd = nil
        if storage['ssh_key'] && storage['ssh_key']!=''
          # use ssh key
          cmd = cmd_rsync
        else
          # use sshpass with password
          cmd = %Q(sshpass -p #{storage['ssh_password']} #{cmd_rsync})
        end


        cmd
      end


      def self.build_ssh_opts(storage)
        ssh_opts = "-p #{storage['ssh_port']||22} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

        if storage['ssh_key'] && storage['ssh_key']!=''
          ssh_opts << " -i #{storage['ssh_key']}"
        end

        ssh_opts
      end

    end
  end
end


