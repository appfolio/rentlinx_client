require 'phony'

module Rentlinx
  # Validator for phone numbers
  class PhoneValidator < BaseValidator
    # Validates and normalizes the phone number with Phony
    def processed_value
      return '' if value_blank?
      return @value unless valid?
      Phony.normalize(@value)
    end

    private

    def validate
      return if value_blank? || Phony.plausible?(@value) || Phony.plausible?('1' + @value)
      @error = "#{@value} is not a valid phone number"
    end
  end
end
