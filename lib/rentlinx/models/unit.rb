require 'rentlinx/modules/photoable'
require 'rentlinx/modules/amenityable'
require 'rentlinx/modules/linkable'

module Rentlinx
  # An object that represents a Rentlinx unit.
  class Unit < Base
    ATTRIBUTES = [:unitID, :propertyID, :name, :description, :rent, :maxRent,
                  :deposit, :maxDeposit, :squareFeet, :maxSquareFeet,
                  :bedrooms, :fullBaths, :halfBaths, :isMobilityAccessible,
                  :isVisionAccessible, :isHearingAccessible, :rentIsBasedOnIncome,
                  :isOpenToLease, :dateAvailable, :dateLeasedThrough, :numUnits,
                  :numAvailable, :address].freeze

    REQUIRED_ATTRIBUTES = [:unitID].freeze

    attr_accessor(*ATTRIBUTES)

    include Rentlinx::Photoable
    # For internal use
    def photo_class
      Rentlinx::UnitPhoto
    end

    include Rentlinx::Amenityable
    # For internal use
    def amenity_class
      Rentlinx::UnitAmenity
    end

    include Rentlinx::Linkable
    # For internal use
    def link_class
      Rentlinx::UnitLink
    end

    # Gets all the photos for a unit.
    #
    # @return a list of Rentlinx::UnitPhoto objects
    def photos
      super.select { |p| p.unitID == unitID }
    end

    # Queries rentlinx and builds a unit with the given ID
    #
    # The returned unit will have all the attributes Rentlinx
    # has for the unit on their end.
    #
    # @param id [String] the rentlinx id of the unit
    # @return a Rentlinx::Unit that is up to date with the remote one
    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
