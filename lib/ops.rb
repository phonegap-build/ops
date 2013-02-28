begin
  require 'bundler/setup'
rescue LoadError
  require 'rubygems'
  require 'bundler'
end

# standard gems
  require 'json'
  require 'etc'
  require 'pathname'

# external gems
  require 'net/ssh'
  require 'i18n'
  require 'rake'
  require 'aws-sdk'

# local includes
  require 'host'

# load all i18n strings
I18n.load_path << Dir[ File.join( "res", "strings/**/*.yml" ) ]
