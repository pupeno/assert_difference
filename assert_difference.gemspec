# -*- encoding: utf-8 -*-
# Copyright © 2011, José Pablo Fernández

$:.unshift File.expand_path("../lib", __FILE__)
require "assert_difference"

Gem::Specification.new do |s|
  s.name = "assert_difference"
  s.version = AssertDifference::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["J. Pablo Fernández"]
  s.email = ["pupeno@pupeno.com"]
  s.homepage = "http://pupeno.github.com/assert_difference/"
  s.summary = "Like Rails' assert_difference, but more powerful"
  s.description = "Like Rails' assert_difference, but more compact and readable syntax through hashes, testing ranges and improved error reporting."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "assert_difference"

  s.add_development_dependency "yard"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test}/*`.split("\n")
end
