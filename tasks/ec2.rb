puts $config

$ec2 = AWS::EC2.new(
    :access_key_id => config[ "AWS" ][ "AccessKeyId" ],
    :secret_access_key => config[ "AWS" ][ "SecretAccessKey" ] )

## Sync EC2 Hosts

namespace "ec2" do

  desc "hosts.sync"
  task "sync" do

  end
end
