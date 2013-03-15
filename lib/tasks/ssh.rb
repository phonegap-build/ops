namespace "hosts" do

  $hosts.each do | i, host |

    namespace host.alias do

      desc I18n.t( "host.ssh", :host => host.alias )
      task "ssh" do
        host.shell!
      end

      desc "Execute a command over ssh"
      task "ssh:exec" do
        command = ENV[ "command" ]
        raise IOError, "Command not specified" if command.nil? ||
          command.empty?

        host.shell_exec! command
      end
    end
  end
end
