# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'consul/kv/version'

Gem::Specification.new do |spec|
  spec.name          = "consul-kv"
  spec.version       = Consul::KV::VERSION
  spec.authors       = ["JGW Maxwell"]
  spec.email         = ["john.maxwell@boardintelligence.co.uk"]
  spec.summary       = %q{Simple wrapper around the Consul KV store.}
  spec.description   = %q{Simple wrapper around the Consul KV store.}
  spec.homepage      = "https://github.com/boardiq/consul-kv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
