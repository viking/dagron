# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dagron/version'

Gem::Specification.new do |gem|
  gem.name          = "dagron"
  gem.version       = Dagron::VERSION
  gem.authors       = ["Jeremy Stephens"]
  gem.email         = ["viking@pillageandplunder.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra'
  gem.add_dependency 'sequel'
  gem.add_dependency 'json'
  gem.add_dependency 'tmx'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-test'
  gem.add_development_dependency 'guard-rack'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'guard-shell'
end
