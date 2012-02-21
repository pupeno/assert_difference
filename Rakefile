# -*- encoding: utf-8 -*-
# Copyright © 2011, José Pablo Fernández

task :default => :test

require "bundler"
Bundler::GemHelper.install_tasks

begin
  require "rake/testtask"
  Rake::TestTask.new(:test) do |test|
    test.libs << "lib" << "test"
    test.pattern = "test/**/test_*.rb"
    test.verbose = true
  end
rescue LoadError => e
  puts "rake is not installed, oh well?"
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
