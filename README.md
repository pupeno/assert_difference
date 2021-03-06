# assert_difference

[![Build Status](https://travis-ci.org/pupeno/assert_difference.png?branch=master)](https://travis-ci.org/pupeno/assert_difference)
[![Code Climate](https://codeclimate.com/github/pupeno/assert_difference.png)](https://codeclimate.com/github/pupeno/assert_difference)
[![Test Coverage](https://codeclimate.com/github/pupeno/assert_difference/badges/coverage.svg)](https://codeclimate.com/github/pupeno/assert_difference)
[![Inline docs](http://inch-ci.org/github/pupeno/assert_difference.png)](http://inch-ci.org/github/pupeno/assert_difference)
[![Gem Version](https://badge.fury.io/rb/assert_difference.png)](http://badge.fury.io/rb/assert_difference)

A nice assert_difference method similar to the one provided by Rails but with some improvements. For example:

```ruby
assert_difference "Company.count" => 1, "User.count" => 5, "Slot.count" => -1 do
  post :something
end
```

will assert that a company and 5 users were create (the plus sign is only for the visual aid) and a slot was removed.

[Rails' assert_difference](http://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html#method-i-assert_difference)
would require a more verbose syntax:

```ruby
assert_difference "Company.count" do
  assert_difference "User.count", 5 do
    assert_difference "Article.count", -1 do
      post :something
    end
  end
end
```

Expectations can also be ranges, for example:

```ruby
assert_difference "Blog.count" => 1, "Post.count" => 2..5 do # Generate some sample posts when creating a blog
  post :create
end
```

On top of that, error reporting is improved by displaying all the counters that didn't match.

To use it with Test::Unit add this code:

```ruby
class Test::Unit::TestCase
  include AssertDifference
end
```

or in Rails:

```ruby
class ActiveSupport::TestCase
  # ...
  include AssertDifference
end
```

and to use it with RSpec:

```ruby
RSpec.configure do |config|
  config.include AssertDifference
end
```

## Support

This gem requires activesupport >= 3.0.0. It is currently being [tested against Ruby 2.2, 2.3, 2.4 and 2.5 with Rails
4.2, 5.0, 5.1 and 5.2](https://travis-ci.org/pupeno/assert_difference), but it's likely to work fine with earlier and 
later versions of both Ruby and Rails (hence the very permissive dependency on activesupport).

Up to version ~> 1.0.0 of this gem, it was [tested with active support 3.0, 3.1, 3.2, 4.0 and 4.1 as well as Ruby 1.9.3,
 2.0 and 2.1](https://travis-ci.org/pupeno/assert_difference/builds/40992839).

## Users

This gem is being used by:

- [Watu](https://watuapp.com)
- [Dashman](https://dashman.tech)
- You? please, let us know if you are using this gem.

## Changelog

### Version 1.0.0 (Nov 14, 2014)
- Modernization of the gem.
- Test with 100% code coverage.
- Started using Travis-CI for continuous testing.
- Started testing in various versions of active support and ruby.
- Improved documentation.

### Version 0.5.0 (Aug 6, 2012)
- Expectations can be ranges.

### Version 0.4.2 (Aug 6, 2012)
- Fixed important typo.

### Version 0.4.1 (Aug 6, 2012)
- Better error reporting (all unmatching counters).

### Version 0.4.0 (Feb 21, 2012)
- Fix crash on missing gems.
- Return what the blocks returns.

### Version 0.3.1 (Aug 25, 2011)
- Fixed documentation.

### Version 0.3.0 (Aug 24, 2011)
- Better organization of code with modules.
- Switched to bundler from jeweler.
- Removed unneeded dependencies.
- Cleaned up documentation.

### Version 0.1.0 (Oct 2, 2010)
- Initial release. Code extracted from a personal project.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Copyright
---------

Copyright © 2010-2018 José Pablo Fernández. See LICENSE for details.
