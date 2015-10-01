module Rentlinx
  # Validator for URLs
  class UrlValidator < BaseValidator
    private

    def validate
      return if value_blank? || valid_url?(@value)
      @error = "#{@value} is not a valid URL"
    end

    def valid_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
end
