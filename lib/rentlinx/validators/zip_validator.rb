module Rentlinx
  class ZipValidator < BaseValidator
    private

    def validate
      return if value_blank? || @value.match(/^\d{5}$/)
      @error = "#{@value} is not a valid zip code, zip codes must be five digits (93117)"
    end
  end
end
