module Rentlinx
  # Validator for phone numbers
  class PhoneValidator < BaseValidator
    # Validates and normalizes the phone number
    def processed_value
      return '' if value_blank?
      return @value unless valid?
      @value.gsub(/[\+\(\)\s\-]/, '')
    end

    private

    def validate
      return if value_blank? || valid_us_phone_number?(processed_value)
      @error = "#{@value} is not a valid phone number"
    end

    def valid_us_phone_number?(number)
      /^1?[2-9][0-9]{2}[2-9][0-9]{6}$/.match(number)
    end
  end
end
