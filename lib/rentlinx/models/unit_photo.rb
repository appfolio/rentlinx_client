module Rentlinx
  # A photo on a unit
  class UnitPhoto < PropertyPhoto
    REQUIRED_ATTRIBUTES += [:unitID]
  end
end
