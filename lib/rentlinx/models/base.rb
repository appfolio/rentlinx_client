require 'rentlinx/validators/attribute_processor_service'

module Rentlinx
  # This is the class on which all other Rentlinx classes are based,
  # it encapsulates much of the important logic used by every class.
  #
  # It should never be instantiated on its own, use one of its
  # subclasses.
  class Base
    # Creates a new instance of the class, but the base class should
    # never be directly instantiated.
    #
    # This method takes in the attributes for the new instance, runs
    # them through the {AttributeProcessor} and saves them as instance
    # variables.
    #
    # @param attrs [Hash] a hash of attributes to save.
    def initialize(attrs)
      @processor = AttributeProcessor.new(attrs.dup)
      attrs = @processor.process
      attributes.each do |at|
        send("#{at}=", attrs[at])
      end
      remaining_attrs = attrs.keys - attributes
      raise UnexpectedAttributes, "Unexpected Attributes: #{remaining_attrs.join(', ')}" if remaining_attrs.compact.size > 0
    end

    # Provides a list of attributes supported by the class.
    #
    # @return an array of attribute keys
    def attributes
      self.class::ATTRIBUTES
    end

    # Provides the list of required attributes for the class (a subset of Class.attributes)
    #
    # @return an array of attribute keys
    def required_attributes
      self.class::REQUIRED_ATTRIBUTES
    end

    # Sends the object to Rentlinx
    #
    # @example
    #     prop = Rentlinx::Property.new(attrs)
    #     prop.post
    def post
      Rentlinx.client.post(self)
    end

    # Removes the object from Rentlinx
    #
    # @example
    #     prop = Rentlinx::Property.new(attrs)
    #     prop.unpost
    def unpost
      Rentlinx.client.unpost(type, send(type.to_s + 'ID'))
    end

    # Converts the object to a hash
    #
    # @return a hash including the attributes and values
    def to_hash
      {}.tap do |hash|
        attributes.each do |at|
          hash[at] = send(at)
        end
      end
    end

    # Determines the validity of the object
    #
    # @return true if valid, false if invalid
    def valid?
      error_messages.empty?
    end

    # Provides error messages on invalid objects
    #
    # @return a hash of error messages
    def error_messages
      @processor = AttributeProcessor.new(to_hash)
      @processor.process

      missing_attrs = required_attributes.select { |at| blank?(send(at)) }

      missing_errors = missing_attrs.each_with_object({}) do |at, obj|
        obj[at] = 'is missing'
      end

      @processor.errors.merge(missing_errors)
    end

    private

    def self.unpost(id)
      Rentlinx.client.unpost(type, id)
    end

    def self.get_from_id(type, id)
      Rentlinx.client.get(type.to_sym, id)
    end

    def type
      self.class.type
    end

    def self.type
      name.split('::').last.downcase.to_sym
    end

    def blank?(str)
      str.nil? || str == ''
    end
  end
end
