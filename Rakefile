# -*- encoding: utf-8 -*-
# Copyright © 2011, José Pablo Fernández

require "rake"
require "rake/testtask"
require "bundler/gem_tasks"

desc "Default: run unit tests."
task :default => :test

desc "Test the table_builder plugin."
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

begin
  require "rcov/rcovtask"
  Rcov::RcovTask.new do |test|
    test.libs << "test"
    test.pattern = "test/**/test_*.rb"
    test.verbose = true
  end
rescue LoadError => e
  puts "rcov is not installed, oh well"
end

begin
  require "yard"
  YARD::Rake::YardocTask.new do |yard|
    # Use Markdown for documentation.
    yard.options << "--markup" << "markdown"
    # Extra file(s).
    yard.options << "-" << "LICENSE"
  end
rescue LoadError => e
  puts "yard is not installed, oh well"
end
