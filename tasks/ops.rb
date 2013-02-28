task "default" do

end

desc I18n.t( "ops.init" )
task "init" do

  name = ENV[ 'name' ]
  fail I18n.t( "ops.init.empty_name" ) if name.nil? || name.empty?

  pwd = Dir.pwd
  FileUtils.mkdir_p( File.join( name, "tmp" ) )

  puts File.expand_path(File.dirname( __FILE__ ))
end
