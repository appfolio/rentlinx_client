module Rentlinx
  class Unit < Base
    ATTRIBUTES = [:unitID, :propertyID, :name, :description, :rent, :maxRent,
                  :deposit, :maxDeposit, :squareFeet, :maxSquareFeet,
                  :bedrooms, :fullBaths, :halfBaths, :isMobilityAccessible,
                  :isVisionAccessible, :isHearingAccessible, :rentIsBasedOnIncome,
                  :isOpenToLease, :dateAvailable, :dateLeasedThrough, :numUnits,
                  :numAvailable]

    REQUIRED_ATTRIBUTES = [:unitID]

    REQUIRED_ATTRIBUTES_FOR_POST = REQUIRED_ATTRIBUTES + [:propertyID]

    attr_accessor(*ATTRIBUTES)

    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
