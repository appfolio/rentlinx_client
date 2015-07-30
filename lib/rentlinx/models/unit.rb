require 'rentlinx/modules/photoable'
require 'rentlinx/modules/amenityable'
require 'rentlinx/modules/linkable'

module Rentlinx
  class Unit < Base
    ATTRIBUTES = [:unitID, :propertyID, :name, :description, :rent, :maxRent,
                  :deposit, :maxDeposit, :squareFeet, :maxSquareFeet,
                  :bedrooms, :fullBaths, :halfBaths, :isMobilityAccessible,
                  :isVisionAccessible, :isHearingAccessible, :rentIsBasedOnIncome,
                  :isOpenToLease, :dateAvailable, :dateLeasedThrough, :numUnits,
                  :numAvailable]

    REQUIRED_ATTRIBUTES = [:unitID]

    attr_accessor(*ATTRIBUTES)

    include Rentlinx::Photoable
    def photo_class
      Rentlinx::UnitPhoto
    end

    include Rentlinx::Amenityable
    def amenity_class
      Rentlinx::UnitAmenity
    end

    include Rentlinx::Linkable
    def link_class
      Rentlinx::UnitLink
    end

    def photos
      super.select { |p| p.unitID == unitID }
    end

    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
