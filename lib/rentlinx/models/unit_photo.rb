module Rentlinx
  class UnitPhoto < BasePhoto
    REQUIRED_ATTRIBUTES_FOR_POST = REQUIRED_ATTRIBUTES + [:unitID]
  end
end
