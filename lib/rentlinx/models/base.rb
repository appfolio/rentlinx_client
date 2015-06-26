module Rentlinx
  class Base
    def initialize(attrs)
      attributes.each do |at|
        send("#{at}=", attrs[at])
      end
      remaining_attrs = attrs.keys - attributes
      raise UnexpectedAttributes, "Unexpected Attributes: #{remaining_attrs.join(', ')}" if remaining_attrs.size > 0
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
      required_attributes.all? do |at|
        !send(at).nil? && send(at) != ''
      end
    end

    def valid_for_post?
      required_attributes_for_post.all? do |at|
        !send(at).nil? && send(at) != ''
      end
    end

    def missing_attributes
      missing = required_attributes.select do |at|
        send(at).nil? || send(at) == ''
      end

      "Missing required attributes: #{missing.join(', ')}"
    end
  end
end
