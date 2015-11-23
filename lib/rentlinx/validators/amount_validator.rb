module Rentlinx
  # Validator for money amounts.
  # Must be positive amounts.
  # Cannot be cleared once set.
  class AmountValidator < BaseValidator
    private

    def validate
      return if !@value.nil? && @value.is_a?(Numeric) && @value >= 0
      @error = "'#{@value}' is not a valid amount."
    end
  end
end
