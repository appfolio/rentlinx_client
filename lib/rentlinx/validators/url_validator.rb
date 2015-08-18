module Rentlinx
  class URLValidator < BaseValidator
    private

    def validate
      return if value_blank? || @value.match(/^https?:\/\/.*\.(com|net|org|us)\/.*$/)
      @error = "#{@value} is not a valid URL"
    end
  end
end
