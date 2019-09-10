require 'rentlinx/modules/photoable'
require 'rentlinx/modules/amenityable'
require 'rentlinx/modules/linkable'

module Rentlinx
  # An object that represents a Rentlinx property.
  class Property < Base
    ATTRIBUTES = [:companyID, :propertyID, :description, :address, :city, :state,
                  :zip, :marketingName, :hideAddress, :latitude, :longitude,
                  :website, :yearBuilt, :numUnits, :phoneNumber, :extension,
                  :faxNumber, :emailAddress, :acceptsHcv, :propertyType,
                  :activeURL, :companyName, :leadsURL,
                  :premium, :capAmount, :rentlinxID].freeze

    REQUIRED_ATTRIBUTES = [:propertyID, :address, :city, :state, :zip,
                           :phoneNumber, :emailAddress].freeze

    attr_accessor(*ATTRIBUTES)

    # Posts the property with all of its attached units.
    #
    # TODO: Discuss whether or not these kinds of methods are needed,
    # or whether we should have post do everything every time.
    def post_with_units
      post
      units.each(&:post) unless units.nil? || units.empty?
    end

    # The list of units attached to the property.
    #
    # If the units list is empty, it will query Rentlinx for the list
    # of units stored on their end.
    #
    # @return a list of Rentlinx::Unit objects
    def units
      @units ||= get_units_for_property_id(propertyID)
    end

    # Allows assigning a list of units to the property.
    #
    # @param unit_list [Array] a list of Rentlinx::Unit objects
    # @return the updated list of Rentlinx::Unit objects
    def units=(unit_list)
      @units = unit_list.map do |unit|
        unit.propertyID = propertyID
        unit
      end
    end

    # Queries rentlinx and builds a property with the given ID.
    #
    # The returned property will have all the attributes Rentlinx
    # has for the property on their end.
    #
    # @param id [String] the rentlinx id of the property
    # @return a Rentlinx::Property that is up to date with the remote one
    def self.from_id(id)
      get_from_id(:property, id)
    end

    # Asks rentlinx for a list of places where the property is posted
    #
    # @param id [String] the rentlinx id of the property
    # @return a list of hashes
    def self.websites(id)
      Rentlinx.client.get_websites(id)
    end

    include Rentlinx::Photoable
    # For internal use.
    def photo_class
      Rentlinx::PropertyPhoto
    end

    include Rentlinx::Amenityable
    # For internal use.
    def amenity_class
      Rentlinx::PropertyAmenity
    end

    include Rentlinx::Linkable
    # For internal use.
    def link_class
      Rentlinx::PropertyLink
    end

    private

    def get_units_for_property_id(id)
      Rentlinx.client.get_units_for_property_id(id)
    end
  end
end
