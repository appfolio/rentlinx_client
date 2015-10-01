module Rentlinx
  # Validator for US postal codes
  class ZipValidator < BaseValidator
    private

    def validate
      return if value_blank? || @value.match(/^\d{5}$|^\d{5}-\d{4}$/)
      @error = "#{@value} is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)"
    end
  end
end
