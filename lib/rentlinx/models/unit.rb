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

    def photos
      @photos ||= get_photos_for_property_id(propertyID).select { |p| p.unitID == unitID }
    end

    def photos=(photos)
      @photos = photos.map do |photo|
        photo.unitID = unitID
        photo.propertyID = propertyID
        photo
      end
    end

    def post_with_photos
      post
      Rentlinx.client.post_photos(@photos)
    end

    def self.from_id(id)
      get_from_id(:unit, id)
    end
  end
end
