module Rentlinx
  class Property < Base
    ATTRIBUTES = [:companyID, :propertyID, :description, :address, :city, :state,
                  :zip, :marketingName, :hideAddress, :latitude, :longitude,
                  :website, :yearBuilt, :numUnits, :phoneNumber, :extension,
                  :faxNumber, :emailAddress, :acceptsHcv, :propertyType,
                  :activeURL, :companyName]

    REQUIRED_ATTRIBUTES = [:propertyID, :address, :city, :state, :zip,
                           :phoneNumber, :emailAddress]

    REQUIRED_ATTRIBUTES_FOR_POST = REQUIRED_ATTRIBUTES + [:companyID, :companyName]

    attr_accessor(*ATTRIBUTES)

    def post_with_units
      post
      units.each(&:post) unless units.nil? || units.empty?
    end

    def units
      @units ||= get_units_for_property_id(propertyID)
    end

    def units=(unit_list)
      @units = unit_list.map do |unit|
        unit.propertyID = propertyID
        unit
      end
    end

    def post_with_photos
      post
      Rentlinx.client.post_photos(@photos)
    end

    def photos
      @photos ||= get_photos_for_property_id(propertyID)
    end

    def photos=(photo_list)
      @photos = photo_list.map do |photo|
        photo.propertyID = propertyID
        photo
      end
    end

    def self.from_id(id)
      get_from_id(:property, id)
    end
  end
end
