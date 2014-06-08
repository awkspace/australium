# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'australium/version'

Gem::Specification.new do |spec|
  spec.name          = "australium"
  spec.version       = Australium::VERSION
  spec.authors       = %w[awk]
  spec.email         = %w[awkisopen@shutupandwrite.net]
  spec.description   = %q[TF2 log parser]
  spec.summary       = %q[TF2 log parser]
  spec.homepage      = "http://training.tf"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
