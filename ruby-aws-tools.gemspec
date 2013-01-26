# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-aws-tools/version"

Gem::Specification.new do |s|
  s.name        = "ruby-aws-tools"
  s.version     = Cwgem::RubyAWS::VERSION
  s.authors     = ["Chris White"]
  s.email       = ["cwhite@engineyard.com"]
  s.homepage    = "http://github.com/engineyard/ruby-aws-tools"
  s.summary     = %q{A gem to work with the AWS API through a command line interface}
  s.description = %q{This gem is meant to provide an interface to work with the Amazon AWS API. It does so through various proxies as well as a command line interface.}

  s.add_dependency 'aws-sdk'
  s.add_dependency 'gli'  
  s.add_dependency 'yard'

  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
