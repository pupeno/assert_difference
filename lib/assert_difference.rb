# encoding: UTF-8
# Copyright © 2010-2018 José Pablo Fernández

require "active_support/core_ext/array/wrap"

require "assert_difference/expectation"

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
  # @param [String, nil] error_message error message to display on top of the description of the expectation failed.
  # @return [Object] whatever the block returned
  def assert_difference(expectations, expected_difference = 1, error_message = nil, &block)
    binding = block.send(:binding)
    if expectations.is_a? Hash
      expectations = expectations.map do |expression, individual_expected_difference|
        Expectation.new(expression, individual_expected_difference, binding)
      end
    else
      expectations = Array.wrap(expectations).map do |expression|
        Expectation.new(expression, expected_difference, binding)
      end
    end

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
end
