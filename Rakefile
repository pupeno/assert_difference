# -*- encoding: utf-8 -*-
# Copyright © 2011, José Pablo Fernández

task :default => :test

require "bundler"
Bundler::GemHelper.install_tasks

require "rake/testtask"
Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/test_*.rb"
  test.verbose = true
end

require "rcov/rcovtask"
Rcov::RcovTask.new do |test|
  test.libs << "test"
  test.pattern = "test/**/test_*.rb"
  test.verbose = true
end

require "yard"
YARD::Rake::YardocTask.new do |yard|
  # Use Markdown for documentation.
  yard.options << "--markup" << "markdown"
  # Extra file(s).
  yard.options << "-" << "LICENSE"
end
