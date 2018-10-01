# Copyright © 2010-2018 José Pablo Fernández

require_relative "test_helper"

require "assert_difference"

class AssertDifferenceTest < MiniTest::Unit::TestCase
  include AssertDifference

  should "pass when change is implicit" do
    value = [1, 2, 3]
    assert_difference "value.count" do
      value << 4
    end
  end

  should "pass when change is explicit" do
    value = [1, 2, 3]
    assert_difference "value.count" => +1 do
      value << 4
    end
  end

  should "pass when change is not 1" do
    value1 = [1, 2, 3]
    value2 = [1, 2, 3]
    value3 = [1, 3, 3]
    assert_difference "value1.count" => +2,
                      "value2.count" => -2,
                      "value3.count" => 0 do
      value1 << 4
      value1 << 5
      value2.delete(3)
      value2.delete(2)
    end
  end

  should "pass when change is a range" do
    value = [1, 2, 3]
    assert_difference "value.count" => -1..3 do
      value << 4
    end
    assert_difference "value.count" => -1..3 do
      value << 5
      value << 6
    end
    assert_difference "value.count" => -1..3 do
      value.delete(1)
    end
    assert_difference "value.count" => -1..3 do
      # no change
    end
  end

  should "fail when change doesn't happen" do
    value = [1, 2, 3]
    assert_raises RuntimeError do
      assert_difference "value.count" do
        # No change
      end
    end
  end

  should "fail when it changes too much" do
    value = [1, 2, 3]
    assert_raises RuntimeError do
      assert_difference "value.count" do
        value << 4
        value << 5
      end
    end
    assert_raises RuntimeError do
      assert_difference "value.count" => 1..3 do
        value << 6
        value << 7
        value << 8
        value << 9
      end
    end
  end
end
