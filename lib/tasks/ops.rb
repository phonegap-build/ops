task "default" do
  puts "run ops -T for a full list of commands"
end

desc I18n.t( "ops.version.desc" )
task "version" do
  puts "Version: #{ Ops.version }"
end

## Project Initialization

desc I18n.t( "ops.init.desc" )
task "init" do

  name = ENV[ 'name' ]
  fail I18n.t( "ops.init.no_name" ) if name.nil? || name.empty?

  FileUtils.cp_r( File.join( Ops::root_dir, "res", "samples", "default" ),
    File.join( Ops::pwd_dir, name ) )
end

begin
  $hosts = Ops::read_hosts
rescue
  $hosts = {}
end

begin
  $config = Ops::read_config
rescue
  $config = {}
end
