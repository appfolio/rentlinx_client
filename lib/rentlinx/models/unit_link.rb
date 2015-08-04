module Rentlinx
  class UnitLink < PropertyLink
    ATTRIBUTES += [:unitID]

    REQUIRED_ATTRIBUTES += [:unitID]

    attr_accessor(*ATTRIBUTES)
  end
end
