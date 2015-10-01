module Rentlinx
  # A module that encapsulates all ammenity related logic for {Rentlinx::Property} and
  # {Rentlinx::Unit} objects. All of these methods can be called on Properties and Units.
  #
  # TODO: Refactor into BaseAble class along with {Linkable} and {Photoable}
  module Amenityable
    # Posts the object with its associated amenities
    #
    # TODO: Discuss whether or not these kinds of methods are needed,
    # or whether we should have post do everything every time.
    def post_with_amenities
      post
      post_amenities
    end

    # Posts the object's amenities
    def post_amenities
      return if @amenities.nil?

      if @amenities.length == 0
        Rentlinx.client.unpost_amenities_for(self)
      else
        Rentlinx.client.post_amenities(@amenities)
      end
    end

    # Loads and caches the list of amenities from Rentlinx.
    #
    # @return a list of amenities
    def amenities
      return @amenities if @amenities

      @amenities =
        if defined? unitID
          Rentlinx.client.get_amenities_for_unit(self)
        else
          Rentlinx.client.get_amenities_for_property_id(propertyID)
        end
    end

    # Allows assignment of amenities to the object.
    #
    # @param amenity_list [Array] an array of amenities
    # @return the list of amenities on the object
    def amenities=(amenity_list)
      @amenities = amenity_list.map do |amenity|
        amenity.propertyID = propertyID
        amenity.unitID = unitID if defined? unitID
        amenity
      end
    end

    # Builds a single amenity and attaches it to the object. This method
    # conveniently assigns the propertyID and unitID (if present) of the
    # parent object, so these need not be passed.
    #
    # @param options [Hash] the attributes for the amenity, defined in
    #   {Rentlinx::PropertyAmenity}
    # @return the updated list of amenities on the object
    def add_amenity(options)
      options.merge!(propertyID: propertyID)
      options.merge!(unitID: unitID) if defined? unitID
      @amenities ||= []
      @amenities << amenity_class.new(options)
    end
  end
end
