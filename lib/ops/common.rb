module Ops

  def self.root_dir
    File.expand_path(
      File.join( File.dirname( __FILE__ ), "..", ".." ) )
  end

  def self.pwd_dir
    Dir.pwd
  end
end
