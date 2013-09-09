module Host
  class Default

    attr_reader :alias, :host_name, :ssh_pem, :user, :tags

    def initialize( host = 'unspecified', info = {}, opts = {} )
      @alias = host

      @host_name = info[ "HostName" ] || nil
      @user = info[ "User" ] || Etc.getlogin
      @ssh_pem = info[ "IdentityFile" ] || nil
      @ssh_port = info[ "Port" ] || nil
      @type = info[ "Type" ] || :default
      @tags = info[ "Tags" ] || {}
      @pem_dirs = opts[ "IdentityLocations" ] || nil
    end

    def type
      @type.to_sym
    end

    def tags=( tags )
      raise IOError, "tags must be a hash" unless tags.kind_of?( Hash )
      @tags = tags
    end

    def matches?( tags )
      tags.each do | tag, value |
        is_regex = value.match( /^\/(.*)\/$/ )

        if is_regex
          regex = Regexp.new( is_regex[ 1 ] )

          unless @tags.has_key?( tag ) && @tags[ tag ].match( regex )
            return false
          end
        else
          unless @tags.has_key?( tag ) && @tags[ tag ] == value
            return false
          end
        end
      end

      true
    end

    def ssh_pem
      ssh_pem = nil

      unless @ssh_pem.nil?
        unless @pem_dirs.nil?
          @pem_dirs.each do | dir |
             f = File.expand_path File.join( dir, "#{ @ssh_pem }*" )
             glob = Dir.glob( f )
             ssh_pem = glob.first unless glob.empty?
          end
        end

        raise( IOError,
          "Error: pem - #{ ssh_pem } not found or not accessable." ) unless
            File.stat( ssh_pem )
      end

      ssh_pem
    end

    def shell!( opts = nil )
      ssh_cmd = [ "ssh" ]

      raise( IOError, "Error: HostName invalid." ) if @host_name.nil?

      ssh_cmd << [ "-l", @user ]
      ssh_cmd << @host_name

      pem = ssh_pem
      ssh_cmd << [ "-i", pem ] unless pem.nil?

      begin
        exec( ssh_cmd.join(" ") )
      rescue => e
        raise( IOError,  "Could not call ssh." )
      end
    end

    def scp_to_host( src, dest )
      scp_cmd = [ "scp" ]

      raise( IOError, "Error: HostName invalid." ) if @host_name.nil?

      scp_cmd << [ "-i", ssh_pem ] unless ssh_pem.nil?
      scp_cmd << "#{ src } #{ @user }@#{ @host_name }:#{ dest }"

      begin
        `#{ scp_cmd.join(" ") }`
      rescue => e
        raise( IOError,  "Could not call scp. #{ e.message }" )
      end
    end

    def shell_exec!( command, opts = {} )
      options = { :keys => ssh_pem }

      color = Color.random_color

      begin
        Net::SSH.start( host_name, user, options ) do | s |

          channel = s.open_channel do |ch|
            channel.request_pty do |ch, success|
              if success
                puts "pty successfully obtained"
              else
                puts "could not obtain pty"
              end
            end if opts.has_key? :pty

            ch.exec( command ) do | ch, success |
              raise( IOError,
                "#{ host_name } > could not execute command" ) unless
                  success

              ch.on_data do | c, data |
                data.split("\n").each do | line |
                  puts "#{ Color.print(
                    self.alias, [ :bold, color ] ) } > #{ line }"
                end
              end

              ch.on_extended_data do |c, type, data|
                data.split("\n").each do | line |
                  puts "#{ Color.print(
                    self.alias, [ :bold, color ] ) } > #{ line }"
                end
              end

              ch.on_close do
                puts "#{ Color.print(
                  self.alias, [ :bold, color ] ) } > COMMAND finished"
              end

            end
          end
        end
      rescue => e
        puts "Error: #{ self.alias } > #{ e.message }".error
      end
    end
  end
end
