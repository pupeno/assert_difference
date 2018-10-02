# encoding: UTF-8
# Copyright © 2010-2018 José Pablo Fernández

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
  # @param [String, Array, Hash] expectations single expectation as a string, an array of expectations or hash table of
  #   expectations and expected difference.
  # @param [Integer, Range, nil] expected_difference expected difference when using an array or single expression.
  # @param [String, nil] message error message to display on top of the description of the expectation failed.
  # @return [Object] whatever the block returned
  def assert_difference(expectations, expected_difference = 1, message = nil, &block)
    binding      = block.send(:binding)
    expectations = expectations_as_hash(expected_difference, expectations) unless expectations.is_a? Hash
    before       = expectations.keys.each_with_object({}) {|expression, before| before[expression] = eval(expression, binding)}

    result = yield

    after          = expectations.keys.each_with_object({}) {|expression, after| after[expression] = eval(expression, binding)}
    error_messages = generate_error_messages(after, before, expectations, message)
    if error_messages.any?
      fail error_messages.join("\n\n").strip
    end

    result
  end

  private

  # Turn an array or a single expression into a hash of expectations and expectations.
  # @param [Integer or Range] expected_difference expected difference when using an array or single expression.
  # @param [Array, String] expectations single or array of expectations to evaluate.
  # @return [Hash] A hash of expressions and the expected difference on each one.
  def expectations_as_hash(expected_difference, expectations)
    Array.wrap(expectations).each_with_object({}) do |expression, new_expectations|
      new_expectations[expression] = expected_difference
    end
  end

  # For the cases in which there isn't a match, generate an error message.
  # @param [Hash] after_values The value after running each of the expressions, as a hash indexed by expression.
  # @param [Hash] before_values The value before running each of the expressions, as a hash indexed by expression.
  # @param [Hash] expected_differences The expected difference for each of the expressions, as a hash indexed by
  #    expression.
  # @param [String] message A custom error message to prepend to the error, same as other assert methods.
  # @return [String] The error message of all the difference failures.
  def generate_error_messages(after_values, before_values, expected_differences, message)
    expected_differences.map do |expression, expected_difference|
      expected_value = generate_expected_value(before_values[expression], expected_difference)
      generate_error_message(after_values[expression], expected_difference, expected_value, expression, message) unless expression_passes?(after_values[expression], expected_value)
    end.compact
  end

  # @param [Integer] after_value The value after running expression.
  # @param [Integer] expected_difference The expected difference between before and after running expression.
  # @param [Integer, Range] expected_value The expected value after running expression.
  # @param [String] expression The expression that was run.
  # @param [String] message The optional error message.
  # @return [String] The error message explaining how the test failed.
  def generate_error_message(after_value, expected_difference, expected_value, expression, message)
    error = "#{expression.inspect} didn't change by #{expected_difference} (expecting #{expected_value}, but got #{after_value})"
    error = "#{message}.\n#{error}" if !message.nil? && !message.blank?
    error
  end

  # Generate the expected value or range based of the value before and the expected difference.
  # @param [Integer] before The result of executing the expression before the test.
  # @param [Integer, Range] expected_difference The expected difference after executing the test.
  # @return [Integer, Range] What the value of the expression should be after executing the test.
  def generate_expected_value(before, expected_difference)
    if expected_difference.is_a? Range
      (before + expected_difference.first)..(before + expected_difference.end)
    else
      before + expected_difference
    end
  end

  # Do the appropriate comparison depending on whether the expectation is a range or a value
  # @param [Integer] actual_difference The difference between executing the expression before and after the test.
  # @param [Integer, Range] expected_difference The expected difference, which might be a range.
  # @return [Boolean] Whether the expression passed the test or not.
  def expression_passes?(actual_difference, expected_difference)
    if expected_difference.is_a?(Range)
      expected_difference.include?(actual_difference)
    else
      expected_difference == actual_difference
    end
  end
end
