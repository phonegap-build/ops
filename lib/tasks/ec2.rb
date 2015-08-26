namespace "hosts" do

  namespace "ec2" do

    ## Sync EC2 Hosts
    desc "hosts.sync"
    task "sync" do
      ec2 = AWS::EC2.new(
          :access_key_id => $config[ "AWS" ][ "AccessKeyId" ],
          :secret_access_key => $config[ "AWS" ][ "SecretAccessKey" ] )

      hosts = {}

      # used if no name is given
      count = 0

      response = ec2.client.describe_instances

      response[:instance_index].each do | instance |

        h = instance[1]

        next if h[:instance_state][:code] == 48 # skip if instance terminated

        tags = {}
        h[:tag_set].each { |tag|
          tags[tag[:key]] = tag[:value]
        }

        name = tags["Name"]

        if name.nil? || name.empty?
          name = "noname-#{ count }"
          count += 1
        end

        if hosts[ name ]
          name = "#{name}.#{ count }"
          count += 1
        end

        ip = h[:dns_name] || "stopped"

        puts "Discovered: #{ name } -> #{ ip }"

        hosts[ name ] = {
          "HostName" => ip,
          "User" => tags["User"],
          "IdentityFile" => h[:key_name],
          "Tags" => tags,
          "Type" => "EC2" }
      end

      puts "Synced #{hosts.count} instances"

      tmp_dir = File.join( Ops::pwd_dir, 'tmp' )
      Dir.mkdir( tmp_dir ) unless File.directory? tmp_dir

      host_file = File.join( tmp_dir, 'hosts.json' )
      File.open( host_file, 'w' ) { | f |  f.write( hosts.to_json ) }

      if Ops::has_bash?
        bash = `which bash`.strip
        `#{ bash } -c "source #{
          File.join( Ops::root_dir, 'autocomplete' ) }"`
      end
    end
  end
end
