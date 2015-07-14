module Rentlinx
  class UnitAmenity < PropertyAmenity
    ATTRIBUTES += [:unitID]

    REQUIRED_ATTRIBUTES += [:unitID]

    attr_accessor(*ATTRIBUTES)
  end
end
