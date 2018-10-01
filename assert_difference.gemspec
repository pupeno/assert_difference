# encoding: UTF-8
# Copyright © 2010-2018 José Pablo Fernández

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "assert_difference/version"

Gem::Specification.new do |spec|
  spec.name          = "assert_difference"
  spec.version       = AssertDifference::VERSION
  spec.authors       = ["J. Pablo Fernández"]
  spec.email         = ["pupeno@pupeno.com"]
  spec.homepage      = "https://github.com/pupeno/assert_difference"
  spec.summary       = "Like Rails' assert_difference, but more powerful"
  spec.description   = "Like Rails' assert_difference, but more compact and readable syntax through hashes, testing ranges and improved error reporting."
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"
  spec.add_dependency "activesupport", ">= 3.0.0"

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda"
end
