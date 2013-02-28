namespace "hosts" do

  desc I18n.t( "hosts.list.desc" )
  task "list" do
    @hosts.each { | h | puts h.alias }
  end

  desc I18n.t( "hosts.sync.desc" )
  task "sync" do
    puts I18n.t( "hosts.sync.in_progress" )
    @hosts = {}

    @ec2.instances.each do | i |
      next unless i.status == :running

      host = i.tags[ "Name" ].downcase

      puts "Discovered host: #{ host }"
      @hosts[ host ] = {
          "HostName" => i.ip_address,
          "User" => i.tags[ "User" ],
          "IdentityFile" => i.key_name
        }
    end 

    File.open( @generated_hosts_file, 'w' ) { | f | f.write( @hosts.to_json ) }
    puts I18n.t( "messages.reload_bash" )
  end

  desc I18n.t( "hosts.add.desc" )
  task "add" do
    required = [ 'hostname', 'host', 'user' ]

    required.each do | p |
      fail I18n.t( "hosts.add.no_#{ p }" ) if ENV[ p ].nil? ||
        ENV[ p ].empty?
    end

    hostname = ENV[ 'hostname' ]
    host = ENV[ 'host' ]
    user = ENV[ 'user' ]
    identity = File.basename( ENV[ 'identity' ] )


    puts "Adding host: #{ host }"
    puts "  => #{ hostname }"
    puts "  => using #{ identity }" unless identity.nil?

    hosts = {}
    hosts_file = File.join( pwd, "hosts.json" )

    hosts = read_hosts( hosts_file ) if File.exists? hosts_file

    exit_failure( "Error: #{ host } is already defined" ) if
      hosts.has_key? host

    hosts[ host ] = {
      'HostName' => hostname,
      'User' => user,
      'IdentityFile' => identity
    }
    
    File.open( hosts_file, 'w' ) { | f | f.write( hosts.to_json ) }
  end

  def read_hosts file
    return {} unless File.exists? file

    hosts = {}

    config = read_config

    begin
      hosts_list = JSON.parse File.read( file )
      hosts_list.each{ | n, i | hosts[ n ] =  Host.new( n, i, config ) }
    rescue JSON::ParserError => e
      exit_failure( "Error parsing hosts file: #{ file }. #{ e.message }" )
    end

    hosts
  end

  def read_config
    config_file = File.join( cwd, "config.json" )

    begin
      config = JSON.parse File.read( config_file )
    rescue JSON::ParserError
      exit_failure( "Error parsing config file: #{ config_file }." )
    end
  end

  def exit_failure( reason="", code=1 )
    puts reason; exit
  end
end
