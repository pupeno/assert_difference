# Copyright © 2010, José Pablo Fernández

require "rubygems"
require "test/unit"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require "assert_difference"

class Test::Unit::TestCase
end
