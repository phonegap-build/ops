namespace "hosts" do

  namespace "ec2" do

    ## Sync EC2 Hosts
    desc "hosts.sync"
    task "sync" do

      opts = { }
      instance_opts = { }
      if $config[ "AWS" ]
        opts[:access_key_id] = $config[ "AWS" ][ "AccessKeyId" ] if $config[ "AWS" ][ "AccessKeyId" ]
        opts[:secret_access_key] = $config[ "AWS" ][ "SecretAccessKey" ] if $config[ "AWS" ][ "SecretAccessKey" ]
        opts[:region] = $config[ "AWS" ][ "Region" ] if $config[ "AWS" ][ "Region" ]
        instance_opts = $config[ "AWS" ][ "InstanceOpts" ] if $config[ "AWS" ][ "InstanceOpts" ]
      end

      ec2 = Aws::EC2::Client.new(opts)

      hosts = {}

      # used if no name is given
      host_count = {}

      response = ec2.describe_instances(instance_opts)

      response[:reservations].each do |reservation|
        reservation[:instances].each do |instance|

          h = instance

          next if h.state.code != 16 # skip if instance not running

          tags = {}
          h.tags.each { |tag|
            tags[tag[:key]] = tag[:value]
          }

          name = tags["Name"]

          if name.nil? || name.empty?
            name = h.private_dns_name
          end

          idx = host_count[ name ] || 1
          host_count[ name ] = idx + 1
          name = "#{name}.#{idx}"

          tags['OriginalName'] = tags['Name']
          tags['Name'] = name
          
          ip = h[:private_dns_name]

          hosts[ name ] = {
            "HostName" => ip,
            "User" => tags["User"],
            "IdentityFile" => h[:key_name],
            "Tags" => tags,
            "Type" => "EC2",
            "Instance-Id" => h[:instance_id]
          }
        end
      end

      hosts.each { |key|
        if key[0] =~ /\.1$/
          base_name = key[0][0..key[0].length-3]
          count = hosts.count {|a| a[0] =~ /^#{base_name}.2/ }
          key[0] = base_name if count == 0
        end
        puts "Discovered: #{ key[0] } -> #{ key[1]['HostName'] }"
      }

      puts "Synced #{hosts.count} instances"

      tmp_dir = File.join( Ops::pwd_dir, 'tmp' )
      Dir.mkdir( tmp_dir ) unless File.directory? tmp_dir

      host_file = File.join( tmp_dir, 'hosts.json' )
      File.open( host_file, 'w' ) { | f |  f.write( hosts.to_json ) }
      autocomplete_cache_file = "#{Ops::pwd_dir}/.autocomplete_cache"
      FileUtils.rm(autocomplete_cache_file) if File.exists?(autocomplete_cache_file) 
      if Ops::has_bash?
        bash = `which bash`.strip
        `#{ bash } -c "source #{
          File.join( Ops::root_dir, 'autocomplete' ) }"`
      end
    end
  end
end
