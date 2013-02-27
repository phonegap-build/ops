class Host

  attr_reader :alias

  def initialize( host = 'unspecified', info = {}, opts = {} )
    @alias = host

    @ssh_host = info[ "HostName" ] || nil
    @ssh_user = info[ "User" ] || Etc.getlogin
    @ssh_pem = info[ "IdentityFile" ] || nil
    @ssh_port = info[ "Port" ] || nil
    @pem_dirs = opts[ "IdentityLocations" ] || nil
  end

  def shell!( opts = nil )
    ssh_cmd = [ "ssh" ]

    unless @ssh_pem.nil?
      unless @pem_dirs.nil?
        @pem_dirs.each do | dir |
           f = File.expand_path File.join( dir, "#{ @ssh_pem}*" )
           glob = Dir.glob( f )
           @ssh_pem = glob.first unless glob.empty?
        end
      end

      raise( IOError, "Error: pem - #{ @ssh_pem } not found or not accessable." ) unless File.stat( @ssh_pem )

      ssh_cmd << [ "-i", @ssh_pem ]
    end

    raise( IOError, "Error: HostName invalid." ) if @ssh_host.nil?

    ssh_cmd << [ "-l", @ssh_user ]
    ssh_cmd << @ssh_host

    begin
      exec( ssh_cmd.join(" ") )
    rescue => e
      raise( IOError,  "Could not call ssh." )
    end
  end
end
