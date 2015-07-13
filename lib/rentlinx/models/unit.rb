require 'rentlinx/modules/photoable'

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

    include Rentlinx::Photoable
    def photo_class
      Rentlinx::UnitPhoto
    end

    def photos
      super.select { |p| p.unitID == unitID }
    end

    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
