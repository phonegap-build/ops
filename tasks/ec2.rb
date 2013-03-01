$ec2 = AWS::EC2.new(
    :access_key_id => $config[ "AWS" ][ "AccessKeyId" ],
    :secret_access_key => $config[ "AWS" ][ "SecretAccessKey" ] )

## Sync EC2 Hosts

namespace "hosts" do

  namespace "ec2" do

    desc "hosts.sync"
    task "sync" do

      $ec2.instances.each do | h |
        name = h.tags[ "Name" ]

        $hosts[ name ] = Host::EC2.new( name, {
          "HostName" => h.ip_address,
          "User" => h.tags[ "User" ],
          "IdentityFile" => h.key_name,
          "Type" => "EC2" }, $config )

      end
    end
  end
end
