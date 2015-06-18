module Rentlinx
  class Unit < Base
    ATTRIBUTES = [:unitID, :propertyID, :name, :description, :rent, :maxRent,
                  :deposit, :maxDeposit, :squareFeet, :maxSquareFeet,
                  :bedrooms, :fullBaths, :halfBaths, :isMobilityAccessible,
                  :isVisionAccessible, :isHearingAccessible, :rentIsBasedOnIncome,
                  :isOpenToLease, :dateAvailable, :dateLeasedThrough, :numUnits,
                  :numAvailable]

    REQUIRED_ATTRIBUTES = [:unitID]

    REQUIRED_FOR_POST = REQUIRED_ATTRIBUTES + [:propertyID]

    attr_accessor(*ATTRIBUTES)

    def attributes
      ATTRIBUTES
    end

    def required_attributes
      REQUIRED_ATTRIBUTES
    end

    def required_attributes_for_post
      REQUIRED_FOR_POST
    end

    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
