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
  require 'pp'

# external gems
  require 'net/ssh'
  require 'i18n'
  require 'rake'
  require 'aws-sdk'

# local includes
  $: << File.dirname(__FILE__)
  require 'version'
  require 'host/list'
  require 'host/default'
  require 'host/e_c_2'
  require 'ops/common'
  require 'ops/console'

# load all i18n strings
I18n.enforce_available_locales = true
string_search = File.join( Ops::root_dir, "res", "strings/**/*.yml" )
string_files = Dir[ string_search ]
I18n.load_path << string_files
