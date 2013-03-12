$hosts.each do | i, host |

  namespace "hosts" do
    namespace host.alias do

      desc "Execute a command over ssh"
      task "ssh:exec" do
        command = ENV[ "command" ]
        raise IOError, "Command not specified" if command.nil? ||
          command.empty?

        host.ssh_pem

        options = { :keys => host.ssh_pem }

        color = Color.random_color

        Net::SSH.start( host.host_name, host.user, options ) do | s |

          channel = s.open_channel do |ch|
            ch.exec( command ) do | ch, success |
              raise IOError,
                "#{ host.host_name } > could not execute command" unless
                  success

              ch.on_data do | c, data |
                data.split("\n").each do | line |
                  puts "#{ Color.print( host.alias, [ :bold, color ] ) } > #{ line }"
                end
              end

              ch.on_extended_data do |c, type, data|
                data.split("\n").each do | line |
                  puts "#{ Color.print( host.alias, [ :bold, color ] ) } > #{ line }"
                end
              end

              ch.on_close do puts
                puts "#{ Color.print( host.alias, [ :bold, color ] ) } > COMMAND finished"
              end
            end
          end
        end
      end
    end
  end
end
