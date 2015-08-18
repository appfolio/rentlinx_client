module Rentlinx
  class UrlValidator < BaseValidator
    private

    def validate
      return if value_blank? || @value.match(%r{^https?:\/\/.*\.(com|net|org|us)\/.*$})
      @error = "#{@value} is not a valid URL"
    end
  end
end
