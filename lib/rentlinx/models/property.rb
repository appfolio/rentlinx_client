require 'rentlinx/modules/photoable'

module Rentlinx
  class Property < Base
    ATTRIBUTES = [:companyID, :propertyID, :description, :address, :city, :state,
                  :zip, :marketingName, :hideAddress, :latitude, :longitude,
                  :website, :yearBuilt, :numUnits, :phoneNumber, :extension,
                  :faxNumber, :emailAddress, :acceptsHcv, :propertyType,
                  :activeURL, :companyName]

    REQUIRED_ATTRIBUTES = [:propertyID, :address, :city, :state, :zip,
                           :phoneNumber, :emailAddress]

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

    def self.from_id(id)
      get_from_id(:property, id)
    end

    include Rentlinx::Photoable
    def photo_class
      Rentlinx::PropertyPhoto
    end
  end
end
