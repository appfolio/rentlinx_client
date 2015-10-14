module Rentlinx
  # Validator for phone numbers
  class PhoneValidator < BaseValidator
    # Validates and normalizes the phone number
    def processed_value
      return '' if value_blank?
      return @value unless valid?
      @value.gsub(/\D/, '')
    end

    private

    def validate
      return if value_blank? ||
                valid_us_number_without_country_code?(processed_value) ||
                valid_us_number_with_country_code?(processed_value)
      @error = "#{@value} is not a valid phone number"
    end

    def valid_us_number_with_country_code?(number)
      number.start_with?('1') && valid_us_number_without_country_code?(number[1..-1])
    end

    def valid_us_number_without_country_code?(number)
      !number.start_with?('1') && !number.start_with?('0') && number.size == 10
    end
  end
end
