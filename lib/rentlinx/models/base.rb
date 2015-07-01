module Rentlinx
  class Base
    def initialize(attrs)
      @processor = AttributeProcessor.new(attrs)
      attrs = @processor.process
      attributes.each do |at|
        send("#{at}=", attrs[at])
      end
      remaining_attrs = attrs.keys - attributes
      raise UnexpectedAttributes, "Unexpected Attributes: #{remaining_attrs.join(', ')}" if remaining_attrs.compact.size > 0
    end

    def attributes
      self.class::ATTRIBUTES
    end

    def required_attributes
      self.class::REQUIRED_ATTRIBUTES
    end

    def required_attributes_for_post
      self.class::REQUIRED_ATTRIBUTES_FOR_POST
    end

    def post
      Rentlinx.client.post(self)
    end

    def unpost
      Rentlinx.client.unpost(type, send(type.to_s + 'ID'))
    end

    def self.unpost(id)
      Rentlinx.client.unpost(type, id)
    end

    def self.get_from_id(type, id)
      Rentlinx.client.get(type.to_sym, id)
    end

    def get_units_for_property_id(id)
      Rentlinx.client.get_units_for_property_id(id)
    end

    def to_hash
      {}.tap do |hash|
        attributes.each do |at|
          hash[at] = send(at)
        end
      end
    end

    def valid?
      error_messages.empty?
    end

    def valid_for_post?
      required_attributes_for_post.none? { |at| blank?(send(at)) }
    end

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
