module Host
  class Default

    attr_reader :alias, :host_name, :ssh_pem, :user

    def initialize( host = 'unspecified', info = {}, opts = {} )
      @alias = host

      @ssh_host = info[ "HostName" ] || nil
      @ssh_user = info[ "User" ] || Etc.getlogin
      @ssh_pem = info[ "IdentityFile" ] || nil
      @ssh_port = info[ "Port" ] || nil
      @type = info[ "Type" ] || :default
      @pem_dirs = opts[ "IdentityLocations" ] || nil
    end

    def type
      @type.to_sym
    end

    def user
      @ssh_user
    end

    def host_name
      @ssh_host
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

      raise( IOError, "Error: HostName invalid." ) if @ssh_host.nil?

      ssh_cmd << [ "-l", @ssh_user ]
      ssh_cmd << @ssh_host

      pem = ssh_pem
      ssh_cmd << [ "-i", pem ] unless pem.nil?

      begin
        exec( ssh_cmd.join(" ") )
      rescue => e
        raise( IOError,  "Could not call ssh." )
      end
    end
  end
end
