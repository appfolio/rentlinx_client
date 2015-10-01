module Rentlinx
  # This is the base validator. It encapsulates all the logic shared
  # between the various validators.
  class BaseValidator
    attr_reader :error

    # Creates a new instance of the class, and validates but
    # BaseValidator should never be directly instantiated.
    def initialize(val)
      @value = val
      @error = ''
      validate
    end

    # Determines the validity of the attribute.
    #
    # @return true if valid, false if invalid
    def valid?
      @error == ''
    end

    # The processed value after validation of the attribute.
    #
    # @return a processed value, a stripped phone number for example
    def processed_value
      @value
    end

    private

    def value_blank?
      @value.nil? || @value == ''
    end
  end
end
