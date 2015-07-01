module Rentlinx
  class AttributeProcessor
    attr_reader :errors
    attr_reader :processed_attrs

    def initialize(attrs)
      @attrs = attrs
      @processed_attrs = @attrs
      @errors = {}
    end

    def process
      validators = { phoneNumber: PhoneValidator, state: StateValidator }

      @attrs.each do |field, val|
        next unless validators.keys.include?(field)
        validator = validators[field].new(val)
        @processed_attrs[field] = validator.processed_value
        @errors[field] = validator.error unless validator.valid?
      end

      @processed_attrs
    end

    def valid?
      @errors.size == 0
    end
  end
end
