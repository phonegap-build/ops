module Ops

  def self.root_dir
    File.expand_path(File.join( $0, "..", ".." ))
  end

  def self.pwd_dir
    return root_dir if File.exists?(File.join( root_dir, 'config.json'))
    nil
  end

  def self.has_bash?
    `which bash`
    ( $? == 0 ) ? true : false
  end

  def self.read_config
    config_file = File.join( self.pwd_dir, "config.json" )

    begin
      config = JSON.parse File.read( config_file )
    rescue JSON::ParserError
      raise IOError, "Error parsing config file: #{ config_file }."
    end
  end

  def self.read_hosts
    config = read_config

    hosts = {}

    hosts_files = [
      File.join( self.pwd_dir, "hosts.json" ),
      File.join( self.pwd_dir, 'tmp' ,"hosts.json" ), ]

    hosts_files.each do | file |
      if File.exists? file
        begin
          json = JSON.parse File.read( file )
          json.each do | n, i |
            hosts[ n ] =  Host::Default.new( n, i, config )
          end
        rescue JSON::ParserError => e
          raise( IOError,
            "Error parsing hosts file: #{ file }. #{ e.message }" )
        end
      end
    end

    hosts
  end
end
