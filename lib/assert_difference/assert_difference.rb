# Copyright © 2010, José Pablo Fernández

module AssertDifference
  # Test numeric difference between the return value of an expression as a result of what is evaluated
  # in the yielded block.
  #
  #   assert_difference "Article.count" do
  #     post :create, :article => {...}
  #   end
  #
  # An arbitrary expression is passed in and evaluated.
  #
  #   assert_difference "assigns(:article).comments(:reload).size" do
  #     post :create, :comment => {...}
  #   end
  #
  # An arbitrary positive or negative difference can be specified. The default is +1.
  #
  #   assert_difference "Article.count", -1 do
  #     post :delete, :id => ...
  #   end
  #
  # An array of expressions can also be passed in and evaluated.
  #
  #   assert_difference [ "Article.count", "Post.count" ], +2 do
  #     post :create, :article => {...}
  #   end
  #
  # A error message can be specified.
  #
  #   assert_difference "Article.count", -1, "An Article should be destroyed" do
  #     post :delete, :id => ...
  #   end
  #
  # Various assertions can be combined into one, instead of writing:
  #
  #   assert_difference "Article.count" do
  #     assert_difference "assigns(:article).comments(:reload).size" do
  #       assert_difference "Article.count", -1 do
  #         post :something
  #       end
  #     end
  #   end
  #
  # you can *now* write:
  #
  #   assert_difference "Article.count" => 1, "assigns(:article).comments(:reload).size" => 1, "Article.count" => -1 do
  #     post :something
  #   end
  def assert_difference(expressions, difference = 1, message = nil, &block)
    b = block.send(:binding)
    if !expressions.is_a? Hash
      exps = Array.wrap(expressions)
      expressions = {}
      exps.each { |e| expressions[e] = difference }
    end

    before = {}
    expressions.each { |exp, _| before[exp] = eval(exp, b) }

    yield

    expressions.each do |exp, diff|
      error = "#{exp.inspect} didn't change by #{diff}"
      error = "#{message}.\n#{error}" if message
      assert_equal(before[exp] + diff, eval(exp, b), error)
    end
  end
end
