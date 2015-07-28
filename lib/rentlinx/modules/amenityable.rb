module Rentlinx
  module Amenityable
    def post_with_amenities
      post
      post_amenities
    end

    def post_amenities
      Rentlinx.client.post_amenities(@amenities)
    end

    def amenities
      return @amenities if @amenities

      @amenities =
        if defined? unitID
          Rentlinx.client.get_amenities_for_unit(self)
        else
          Rentlinx.client.get_amenities_for_property_id(propertyID)
        end
    end

    def amenities=(amenity_list)
      @amenities = amenity_list.map do |amenity|
        amenity.propertyID = propertyID
        amenity.unitID = unitID if defined? unitID
        amenity
      end
    end

    def add_amenity(options)
      options.merge!(propertyID: propertyID)
      options.merge!(unitID: unitID) if defined? unitID
      @amenities ||= []
      @amenities << amenity_class.new(options)
    end
  end
end
