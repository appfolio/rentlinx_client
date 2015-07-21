module Rentlinx
  class PropertyAmenity < Base
    ATTRIBUTES = [:details, :name, :propertyID]

    REQUIRED_ATTRIBUTES = [:name, :propertyID]

    attr_accessor(*ATTRIBUTES)

    def to_hash
      { details: details, name: name }
    end
  end
end
