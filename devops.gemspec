require './lib/version.rb'

files = `git ls-files`.split("\n")

Gem::Specification.new do |s|
  s.name        = 'devops'
  s.version     = Ops::version
  s.date        = Time.new
  s.summary     = "Ops tool for remote servers"
  s.description = "Ops tool for remote servers (EC2 etc.)"
  s.authors     = [ "Hardeep Shoker", "Ryan Willoughby", "Brett Rudd" ]
  s.email       = 'hardeepshoker@gmail.com'
  s.homepage    = 'https://github.com/hardeep/ops'
  s.files       = files
  s.licenses    = "MIT"
  s.required_ruby_version = '~> 2.3'
  s.bindir = 'bin'
  s.require_paths = ["lib"]
  s.executables = [ 'ops' ]
  s.add_dependency('bundler', '~>1.12')
  s.add_dependency('i18n', '~>0.7')
  s.add_dependency('aws-sdk', '~>2.4')
  s.add_dependency('net-ssh', '<3')
  s.add_dependency('json', '~>2.0')
  s.add_dependency('rake', '~>11.2')
end
