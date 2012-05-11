# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pollinate/version"

Gem::Specification.new do |s|
  s.name     = 'Pollinate'
  s.version  = Pollinate::VERSION
  s.date     = Date.today.strftime('%Y-%m-%d')
  s.authors  = ["NerdHive Industries LLC"]
  s.email    = 'support@nerdhiveindustries.com'
  s.homepage = 'http://github.com/nerdhiveindustries/pollinate'
  s.summary     = "Generate a Rails app using NerdHive Industries' best practices."

  s.description = <<-HERE
Pollinate is a base Rails project that you can upgrade. It is used by
NerdHive Industries to get a jump start on a working app. Use pollinate if you're in a
rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.files = `git ls-files`.split("\n").
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('rails', '3.2.3')
  s.add_dependency('bundler', '>= 1.1.2')

  s.add_development_dependency('cucumber', '~> 1.1.0')
  s.add_development_dependency('aruba', '~> 0.4.6')
end
