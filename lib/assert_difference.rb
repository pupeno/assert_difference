require "active_support/core_ext/array/wrap"
require "assert_difference/expectation"

# This is the AssertDifference module, which you should include on your test class to be able to use the
# {#assert_difference} method. To use it with Test::Unit add this code:
#
#   class Test::Unit::TestCase
#     include AssertDifference
#   end
#
# or in Rails:
#
#   class ActiveSupport::TestCase
#     # ...
#     include AssertDifference
#   end
#
# and to use it with RSpec:
#
#   RSpec.configure do |config|
#     config.include AssertDifference
#   end
#
# @author José Pablo Fernández
module AssertDifference
  # Test numeric difference between the return value of an expression as a result of what is evaluated
  # in the yielded block.
  #
  #     assert_difference "Article.count" do
  #       post :create, :article => {...}
  #     end
  #
  # An arbitrary expression is passed in and evaluated.
  #
  #     assert_difference "assigns(:article).comments(:reload).size" do
  #       post :create, :comment => {...}
  #     end
  #
  # An arbitrary positive or negative difference can be specified. The default is 1.
  #
  #     assert_difference "Article.count", -1 do
  #       post :delete, :id => ...
  #     end
  #
  # An array of expressions can also be passed in and evaluated.
  #
  #     assert_difference ["Article.count", "Post.count"], 2 do
  #       post :create, :article => {...}
  #     end
  #
  # A error message can be specified.
  #
  #     assert_difference "Article.count", -1, "An Article should be destroyed" do
  #       post :delete, :id => ...
  #     end
  #
  # Various assertions can be combined into one, instead of writing:
  #
  #     assert_difference "Company.count" do
  #       assert_difference "User.count", 5 do
  #         assert_difference "Article.count", -1 do
  #           post :something
  #         end
  #       end
  #     end
  #
  # you can *now* write:
  #
  #     assert_difference "Company.count" => 1, "User.count" => 5, "Article.count" => -1 do
  #       post :something
  #     end
  #
  # the results of the block is the result of the assert, so you can write:
  #
  #     email = assert_difference "ActionMailer::Base.deliveries.count" => 1 do
  #         Mailer.reset_password_email(@user).deliver
  #     end
  #     assert_equal [@user.email], email.to
  #
  # the expectations can also be ranges, for example:
  #
  #     assert_difference "Article.count" => 1, "sample_comments.count" => 2..4 do
  #       post :something
  #     end
  #
  # @param [String, Array<String>, Hash<String, [Integer, Range]>] expectations Single expectation as a string, an array of expectations or hash table of
  #   expectations and expected difference.
  # @param [Integer, Range, nil] expected_difference Expected difference when using an array or single expression.
  # @param [String, nil] error_message Error message to display on top of the description of the expectation failed.
  # @return [Object] Whatever the block returned.
  def assert_difference(expectations, expected_difference = nil, error_message = nil, &block)
    binding      = block.send(:binding)
    expectations = generate_expectations(expectations, expected_difference, binding)

    result = yield

    expectations.map &:eval_after

    failed_expectations = expectations.reject &:passed?
    if failed_expectations.any?
      all_error_messages = failed_expectations.map(&:error_message).join("\n\n").strip
      all_error_messages = "#{error_message}.\n#{all_error_messages}" unless error_message.nil?
      fail all_error_messages
    end

    result
  end

  private

  # Generate the array of expectations.
  #
  # @param [String, Array<String>, Hash<String, [Integer, Range]>] expectations Single expectation as a string, an array of expectations or hash table of
  #   expectations and expected difference.
  # @param [Integer, Range, nil] expected_difference Expected difference when using an array or single expression.
  # @param [Binding] binding The context in which the expressions are run.
  # @return [Array<Expectation>] Returns an array of {AssertDifference::Expectation} objects.
  def generate_expectations(expectations, expected_difference, binding)
    if expectations.is_a? Hash
      raise Exception.new("When passing a hash of expressions/expectations, cannot define a global expectation.") unless expected_difference.nil?
      expectations.map do |expression, individual_expected_difference|
        Expectation.new(expression, individual_expected_difference, binding)
      end
    else
      Array.wrap(expectations).map do |expression|
        Expectation.new(expression, expected_difference || 1, binding)
      end
    end
  end
end
