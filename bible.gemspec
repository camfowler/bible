# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bible/version'

Gem::Specification.new do |spec|
  spec.name          = 'bible'
  spec.version       = Bible::VERSION
  spec.authors       = ['Cameron Fowler']
  spec.email         = ['hiding.in.a.box@gmail.com']
  spec.summary       = %q{A ruby implementation of the bible-kjv package available on Ubuntu}
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sqlite3'
  spec.add_runtime_dependency 'rb-readline'
  spec.add_runtime_dependency 'fuzzy_match'
  spec.add_runtime_dependency 'word_wrap'
  spec.add_runtime_dependency 'gli'
  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'spec'
  spec.add_development_dependency 'pry'

end
