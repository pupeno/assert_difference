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
  s.homepage = "http://github.com/pupeno/assert_difference"
  s.summary = "An improved assert_difference"
  s.description = "Better assert_difference than Rails by providing a more compact and readable syntax through hashes. For some more information read http://pupeno.com/blog/better-assert-difference."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "assert_difference"

  s.add_development_dependency "yard"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test}/*`.split("\n")
end
