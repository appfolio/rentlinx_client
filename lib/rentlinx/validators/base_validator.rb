module Rentlinx
  class BaseValidator
    attr_reader :error

    def initialize(val)
      @value = val
      @error = ''
      validate
    end

    def valid?
      @error == ''
    end

    def processed_value
      @value
    end

    def value_blank?
      @value.nil? || @value == ''
    end
  end
end
