module Rentlinx
  class Property < Base
    ATTRIBUTES = [:companyID, :propertyID, :description, :address, :city, :state,
                  :zip, :marketingName, :hideAddress, :latitude, :longitude,
                  :website, :yearBuilt, :numUnits, :phoneNumber, :extension,
                  :faxNumber, :emailAddress, :acceptsHcv, :propertyType,
                  :activeURL, :companyName]

    REQUIRED_ATTRIBUTES = [:propertyID, :address, :city, :state, :zip,
                           :phoneNumber, :emailAddress]

    REQUIRED_FOR_POST = REQUIRED_ATTRIBUTES + [:companyID, :companyName]

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
      get_from_id(:property, id)
    end
  end
end
