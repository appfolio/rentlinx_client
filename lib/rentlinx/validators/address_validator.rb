module Rentlinx
  # Validator for addresses
  #
  # Ensures they are three or more characters.
  class AddressValidator < BaseValidator
    private

    def validate
      return if !@value.nil? && @value.length > 2
      @error = "'#{@value}' is not a valid address, an address must be 3 characters or more."
    end
  end
end
