module Rentlinx
  # An amenity on a propery
  class PropertyAmenity < Base
    ATTRIBUTES = [:details, :name, :propertyID]

    REQUIRED_ATTRIBUTES = [:name, :propertyID]

    attr_accessor(*ATTRIBUTES)

    # Converts the object to a hash
    #
    # @return a hash with the details and name of the link
    def to_hash
      { details: details, name: name }
    end
  end
end
