module Rentlinx
  # Validator for money amounts.
  # Must be positive amounts.
  # Cannot be cleared once set.
  class AmountValidator < BaseValidator
    private

    def validate
      @value.sub!(/^0+/, '') unless @value.nil?
      return if @value.to_s =~ /[1-9]\d*(\.\d{1,2})?/
      @error = "'#{@value}' is not a valid amount."
    end
  end
end
