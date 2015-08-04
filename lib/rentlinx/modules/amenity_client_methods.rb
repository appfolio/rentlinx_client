module Rentlinx
  module AmenityClientMethods
    def post_amenities(amenities)
      raise Rentlinx::InvalidObject, amenities.find { |a| !a.valid? } unless amenities.all?(&:valid?)
      raise Rentlinx::InvalidObject, amenities unless amenities.all? { |p| p.propertyID == amenities.first.propertyID }
      property_amenities = amenities.select { |p| p.class == Rentlinx::PropertyAmenity }
      unit_amenities = amenities - property_amenities

      post_property_amenities(property_amenities) unless property_amenities.empty?
      post_unit_amenities(unit_amenities) unless unit_amenities.empty?
    end

    def get_amenities_for_property_id(id)
      data = request('GET', "properties/#{id}/amenities")['data']
      data.map do |amenity_data|
        if amenity_data['unitID'].nil? || amenity_data['unitID'] == ''
          amenity_data.delete('unitID')
          PropertyAmenity.new(symbolize_data(amenity_data))
        else
          UnitAmenity.new(symbolize_data(amenity_data))
        end
      end
    rescue Rentlinx::NotFound
      return []
    end

    def get_amenities_for_unit(unit)
      amenities = get_amenities_for_property_id(unit.propertyID)
      amenities.select { |a| defined? a.unitID && a.unitID == unit.unitID }
    end

    def unpost_amenity(amenity)
      case amenity
      when Rentlinx::UnitAmenity
        unpost_unit_amenity(amenity.unitID, amenity.name)
      when Rentlinx::PropertyAmenity
        unpost_property_amenity(amenity.propertyID, amenity.name)
      else
        raise TypeError, "Invalid type: #{amenity.class}"
      end
    end

    private

    # post_amenities should only be called from property or unit, so we don't need
    # to handle multiple properties
    def post_property_amenities(amenities)
      request('PUT', "properties/#{amenities.first.propertyID}/amenities", amenities.map(&:to_hash))
    end

    def post_unit_amenities(amenities)
      hash = {}
      amenities.each do |p|
        if hash.keys.include?(p.unitID)
          hash[p.unitID] << p
        else
          hash[p.unitID] = [p]
        end
      end

      hash.each do |unitID, unit_amenities|
        request('PUT', "units/#{unitID}/amenities", unit_amenities.map(&:to_hash))
      end
    end

    def unpost_property_amenity(id, name)
      request('DELETE', URI.encode("properties/#{id}/amenities/#{name}"))
    end

    def unpost_unit_amenity(id, name)
      request('DELETE', URI.encode("units/#{id}/amenities/#{name}"))
    end
  end
end
