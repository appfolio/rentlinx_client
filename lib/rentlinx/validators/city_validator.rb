module Rentlinx
  # Validator for cities
  #
  # Ensures they are three or more characters.
  class CityValidator < BaseValidator
    private

    def validate
      return if !@value.nil? && @value.length > 2
      @error = "'#{@value}' is not a valid city, a city must be 3 characters or more."
    end
  end
end
