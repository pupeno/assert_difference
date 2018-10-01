# encoding: UTF-8
# Copyright © 2010-2018 José Pablo Fernández

require "rubygems"

require "minitest/autorun"
require "minitest/reporters"
MiniTest::Reporters.use!
require "shoulda"
require "shoulda-context"

# Make the code to be tested easy to load.
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
