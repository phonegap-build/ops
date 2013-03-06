require 'lib/version.rb'

files = `git ls-files`.split("\n")

Gem::Specification.new do |s|
  s.name        = 'Ops'

  s.version     = Ops::version

  s.date        = Time.new

  s.summary     = "Ops tool for remote servers"
  s.description = "Ops tool for remote servers"

  s.authors     = [ "Hardeep Shoker", "Ryan Willoughby" ]
  s.email       = 'hardeepshoker@gmail.com'
  s.homepage    = 'https://github.com/hardeep/ops'

  s.files       = files

  s.bindir = 'bin'
  s.executables = [ 'ops' ]
end
