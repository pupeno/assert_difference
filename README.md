assert_difference
=================

A nice assert_difference method similar to the one provided by Rails but with
some improvements. For example:

    assert_difference "Company.count" => +1, "User.count" => +5, "Slot.count" => -1 do
      post :something
    end

will assert that a company and 5 users were create (the plus sign is only for
the visual aid) and a slot was removed.

[Rails' assert_difference](http://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html#method-i-assert_difference)
would require a more verbose syntax:

    assert_difference "Company.count" do
      assert_difference "User.count", +5 do
        assert_difference "Article.count", -1 do
          post :something
        end
      end
    end

Expectations can also be ranges, for example:

    assert_difference "Blog.count" => +1, "Post.count" => 2..5 do # Generate some sample posts when creating a blog
      post :create
    end

On top of that, error reporting is improved by displaying all the counters that didn't match except only one.

To use it with Test::Unit add this code:

    class Test::Unit::TestCase
      include AssertDifference
    end

or in Rails:

    class ActiveSupport::TestCase
      # ...
      include AssertDifference
    end

and to use it with RSpec:

    RSpec.configure do |config|
      config.include AssertDifference
    end

For more information read http://pupeno.com/blog/better-assert-difference

Notes on contributing
---------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.
* Document any new options and verify the documentation looks correct by running:

      yard server --reload

  and going to http://localhost:8808

Copyright
---------

Copyright (c) 2010, 2011, 2012 José Pablo Fernández. See LICENSE for details.
