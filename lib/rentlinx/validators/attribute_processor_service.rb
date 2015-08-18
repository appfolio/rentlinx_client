require 'rentlinx/validators/base_validator'
require 'rentlinx/validators/phone_validator'
require 'rentlinx/validators/state_validator'
require 'rentlinx/validators/zip_validator'
require 'rentlinx/validators/url_validator'

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
      validators = { phoneNumber: PhoneValidator,
                     state: StateValidator,
                     zip: ZipValidator,
                     leadsURL: URLValidator }

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
