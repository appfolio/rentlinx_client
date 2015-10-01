module Rentlinx
  # An amenity on a unit
  class UnitAmenity < PropertyAmenity
    ATTRIBUTES += [:unitID]

    REQUIRED_ATTRIBUTES += [:unitID]

    attr_accessor(*ATTRIBUTES)
  end
end
