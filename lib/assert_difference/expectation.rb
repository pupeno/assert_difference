module AssertDifference
  # This class represents a single expectations of the many that can be present in an assert_difference.
  #
  # This class is intended to be private to assert_difference and not used directly.
  #
  # @author José Pablo Fernández
  class Expectation
    DEFAULT_EXPECTATION = 1

    attr_accessor :expression, :expected_difference, :binding, :before_value, :after_value, :expected_value

    # Build an expectation.
    #
    # @param [String] expression The expression to be evaluated.
    # @param [Integer, Range] expected_difference The expected difference between running the expression before and
    #   after the body of the test.
    # @param [Binding] binding The context for the expressions to be evaluated in.
    def initialize(expression, expected_difference, binding)
      self.expression          = expression
      self.expected_difference = expected_difference
      self.binding             = binding

      self.before_value   = eval_expression
      self.expected_value = generate_expected_value
    end

    # Evaluate the expression and save the result as the after value, to be compared with the expected value.
    def eval_after
      self.after_value = eval_expression
    end

    # Returns whether the expectation passed or not.
    #
    # @return [Boolean] Whether the expectation passed or not.
    def passed?
      if expected_value.is_a?(Range)
        expected_value.include?(after_value)
      else
        expected_value == after_value
      end
    end

    # Generates the error message for this expectation. Returns nil if the expectation passed.
    #
    # @return [String, nil] The error message or nil if there's none.
    def error_message
      unless passed?
        "#{expression.inspect} didn't change by #{expected_difference} (expecting #{expected_value}, but got #{after_value})"
      end
    end

    # Build an array of expectations from a single, an array or a hash of raw expectations.
    #
    # @param [String, Array<String>, Hash<String, [Integer, Range]>] expectations Single expectation as a string, an array of expectations or hash table of
    #   expectations and expected difference.
    # @param [Integer, Range, nil] expected_difference Expected difference when using an array or single expression.
    # @param [Binding] binding The context in which the expressions are run.
    # @return [Array<Expectation>] Returns an array of {AssertDifference::Expectation} objects.
    def self.build_expectations(expectations, expected_difference, binding)
      if expectations.is_a? Hash
        raise Exception.new("When passing a hash of expressions/expectations, cannot define a global expectation.") unless expected_difference.nil?
        expectations.map do |expression, expected_difference|
          Expectation.new(expression, expected_difference, binding)
        end
      else
        Array.wrap(expectations).map do |expression|
          Expectation.new(expression, (expected_difference || DEFAULT_EXPECTATION), binding)
        end
      end
    end

    private

    # Generate the expected value.
    #
    # @return [Integer, Range] Generate the expected value.
    def generate_expected_value
      if expected_difference.is_a? Range
        (before_value + expected_difference.first)..(before_value + expected_difference.end)
      else
        before_value + expected_difference
      end
    end

    # Evaluate the expression in the context of the binding.
    #
    # @return [Object] Whatever the expression returns.
    def eval_expression
      eval(expression, binding)
    end

  end

  private_constant :Expectation
end