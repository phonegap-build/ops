namespace "hosts" do

  desc I18n.t( "hosts.list.desc" )
  task "list" do
    hosts = Ops::read_hosts
    hosts.each do | i, h |
      puts "#{ h.alias }"
    end
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
    type = ENV[ 'type' ] || "default"
    identity = nil
    tags = {}

    unless ENV[ 'identity' ].nil?
      identity = File.basename( ENV[ 'identity' ] )
    end

    unless ENV[ 'tags' ].nil?
      tags = File.basename( ENV[ 'tags' ] )
      tags = JSON.parse( tags )
    end


    puts "Adding host: #{ host }"
    puts "  => #{ hostname }"
    puts "  => using #{ identity }" unless identity.nil?

    hosts = {}
    hosts_file = File.join( pwd, "hosts.json" )

    if File.exists? hosts_file
      hosts = JSON.parse( File.read( hosts_file ) )
    end

    exit_failure( "Error: #{ host } is already defined" ) if
      hosts.has_key? host

    hosts[ host ] = {
      'HostName' => hostname,
      'User' => user,
      'IdentityFile' => identity,
      "Type" => "type",
      "Tags" => tags
    }
    
    File.open( hosts_file, 'w' ) { | f | f.write( hosts.to_json ) }
  end
end
