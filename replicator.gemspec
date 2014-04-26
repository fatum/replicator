# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'replicator/version'

Gem::Specification.new do |spec|
  spec.name          = "replicator"
  spec.version       = Replicator::VERSION
  spec.authors       = ["Maxim Filippovich"]
  spec.email         = ["fatumka@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "mock_redis"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "awesome_print"

  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "aws"
  spec.add_development_dependency "redis-objects"
end