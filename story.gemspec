# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'story/meta'

Gem::Specification.new do |spec|
  spec.name          = 'story'
  spec.version       = Story::Meta::VERSION
  spec.authors       = ['Rozzy']
  spec.email         = ['berozzy@gmail.com']
  spec.description   = %q{Ruby blog engine}
  spec.summary       = %q{Simple blog engine}
  spec.homepage      = 'https://github.com/rozzy/story'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
