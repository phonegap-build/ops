## Sync EC2 Hosts

namespace "hosts" do

  namespace "ec2" do

    desc "hosts.sync"
    task "sync" do
      aws_config

      hosts = {}

      # used if no name is given
      count = 0

      $ec2.instances.each do | h |
        name = h.tags[ "Name" ]

        if name.nil? || name.empty?
          name = "noname-#{ count }"
          count += 1
        end

        ip = h.ip_address || "stopped"

        puts "Discovered: #{ name } -> #{ ip }"

        hosts[ name ] = {
          "HostName" => ip,
          "User" => h.tags[ "User" ],
          "IdentityFile" => h.key_name,
          "Type" => "EC2" }
      end

      tmp_dir = File.join( pwd_dir, 'tmp' )
      Dir.mkdir( tmp_dir ) unless File.directory? tmp_dir

      host_file = File.join( tmp_dir, 'hosts.json' )
      File.open( host_file, 'w' ) { | f |  f.write( hosts.to_json ) }
    end

    def aws_config
      raise IOError, "config not loaded"  if !defined? $config

      $ec2 = AWS::EC2.new(
          :access_key_id => $config[ "AWS" ][ "AccessKeyId" ],
          :secret_access_key => $config[ "AWS" ][ "SecretAccessKey" ] )
    end
  end
end
