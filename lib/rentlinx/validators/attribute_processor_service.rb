require 'rentlinx/validators/base_validator'
require 'rentlinx/validators/city_validator'
require 'rentlinx/validators/phone_validator'
require 'rentlinx/validators/state_validator'
require 'rentlinx/validators/url_validator'
require 'rentlinx/validators/zip_validator'

module Rentlinx
  # Provides processing and validation for attributes on {Rentlinx::Property} and
  # {Rentlinx::Unit} objects
  class AttributeProcessor
    attr_reader :errors
    attr_reader :processed_attrs

    # @param attrs [Hash] the attributes to be processed
    def initialize(attrs)
      @attrs = attrs
      @processed_attrs = @attrs
      @errors = {}
    end

    # Processes the attributes, both validating them and processing them
    # into a format suitable for Rentlinx.
    #
    # This method also populates the errors attribute, so it must be run
    # before calling .valid? or querying for errors.
    #
    # Currently, phone number, state, zip, and leads URL are validated.
    # They are passed into their own validator objects: {PhoneValidator},
    # {StateValidator}, {ZipValidator}, and {UrlValidator}
    #
    # @return the processed attributes ready to submit to Rentlinx
    def process
      validators = { phoneNumber: PhoneValidator,
                     state: StateValidator,
                     zip: ZipValidator,
                     leadsURL: UrlValidator,
                     city: CityValidator }

      @attrs.each do |field, val|
        next unless validators.keys.include?(field)
        validator = validators[field].new(val)
        @processed_attrs[field] = validator.processed_value
        @errors[field] = validator.error unless validator.valid?
      end

      @processed_attrs
    end

    # Determines the validity of the attributes it contains.
    #
    # @return [Boolean] true if valid, false if not
    def valid?
      @errors.size == 0
    end
  end
end
