# encoding: UTF-8
# Copyright © 2010, 2011, 2012, 2014 José Pablo Fernández

require "active_support/core_ext/array/wrap"

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
  # An arbitrary positive or negative difference can be specified. The default is +1.
  #
  #     assert_difference "Article.count", -1 do
  #       post :delete, :id => ...
  #     end
  #
  # An array of expressions can also be passed in and evaluated.
  #
  #     assert_difference [ "Article.count", "Post.count" ], +2 do
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
  #       assert_difference "User.count", +5 do
  #         assert_difference "Article.count", -1 do
  #           post :something
  #         end
  #       end
  #     end
  #
  # you can *now* write:
  #
  #     assert_difference "Article.count" => 1, "assigns(:article).comments(:reload).size" => 1, "Article.count" => -1 do
  #       post :something
  #     end
  #
  # the results of the block is the result of the assert, so you can write
  #
  #     email = assert_difference "ActionMailer::Base.deliveries.count" => +1 do
  #         Mailer.reset_password_email(@user).deliver
  #     end
  #     assert_equal [@user.email], email.to
  #
  # the expectations can also be ranges, for example:
  #
  #     assert_difference "Article.count" => 1, "sample_coments.count" => 2..4 do
  #       post :something
  #     end
  #
  # @param [Array, Hash] expressions array of expressions to evaluate or hash
  #   table of expressions and expected difference.
  # @param [Integer or Range] expected_difference expected difference when using an array or single expression.
  # @param [String, nil] message error message to display. One would be constructed if nil.
  # @return whatever the block returned
  def assert_difference(expressions, expected_difference = 1, message = nil, &block)
    binding = block.send(:binding)
    expressions = expressions_as_hash(expected_difference, expressions) unless expressions.is_a? Hash
    before = expressions.keys.each_with_object({}) { |exp, before| before[exp] = eval(exp, binding) }

    result = yield

    error_messages = []
    expressions.each do |exp, expected_difference|
      expected_value = if expected_difference.is_a? Range
                         (before[exp] + expected_difference.first)..(before[exp] + expected_difference.end)
                       else
                         before[exp] + expected_difference
                       end
      actual_difference = eval(exp, binding)
      if expected_value.is_a?(Range) ? !expected_value.include?(actual_difference) : expected_value != actual_difference
        error = "#{exp.inspect} didn't change by #{expected_difference} (expecting #{expected_value}, but got #{actual_difference})"
        error = "#{message}.\n#{error}" if message
        error_messages << error
      end
    end

    if error_messages.any?
      fail error_messages.join(error_messages.any? { |m| m.include? "\n" } ? "\n\n" : ". ").strip
    end

    return result
  end

  private

  # Turn an array or a single expression into a hash of expressions and expectations.
  def expressions_as_hash(expected_difference, expressions)
      Array.wrap(expressions).each_with_object({}) { |expression, expressions| expressions[expression] = expected_difference }
  end
end
