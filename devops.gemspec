require './lib/version.rb'

files = `git ls-files`.split("\n")

Gem::Specification.new do |s|
  s.name        = 'devops'

  s.version     = Ops::version

  s.date        = Time.new

  s.summary     = "Ops tool for remote servers"
  s.description = "Ops tool for remote servers"

  s.authors     = [ "Hardeep Shoker", "Ryan Willoughby" ]
  s.email       = 'hardeepshoker@gmail.com'
  s.homepage    = 'https://github.com/hardeep/ops'

  s.files       = files

  s.bindir = 'bin'
  s.require_paths = ["lib"]
  s.executables = [ 'ops' ]

  s.add_dependency('bundler')
  s.add_dependency('i18n')
  s.add_dependency('aws-sdk')
end
