module Rentlinx
  module AmenityClientMethods
    def post_amenities(amenities)
      return if amenities.nil?
      raise(Rentlinx::InvalidObject, amenities.find { |a| !a.valid? }) unless amenities.all?(&:valid?)
      raise(Rentlinx::IncompatibleGroupOfObjectsForPost, 'propertyID') unless amenities.all? { |p| p.propertyID == amenities.first.propertyID }

      property_amenities = amenities.select { |p| p.class == Rentlinx::PropertyAmenity }
      unit_amenities = amenities - property_amenities

      post_property_amenities(property_amenities) unless property_amenities.empty?
      post_unit_amenities(unit_amenities) unless unit_amenities.empty?
    end

    def unpost_amenities_for(object)
      case object
      when Rentlinx::Unit
        post_amenities_for_unit_id(object.unitID, [])
      when Rentlinx::Property
        post_amenities_for_property_id(object.propertyID, [])
      else
        raise TypeError, "Type not permitted: #{object.class}"
      end
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
      post_amenities_for_property_id(amenities.first.propertyID, amenities)
    end

    def post_amenities_for_property_id(id, amenities)
      request('PUT', "properties/#{id}/amenities", amenities.map(&:to_hash))
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
        post_amenities_for_unit_id(unitID, unit_amenities)
      end
    end

    def post_amenities_for_unit_id(id, amenities)
      request('PUT', "units/#{id}/amenities", amenities.map(&:to_hash))
    end

    def unpost_property_amenity(id, name)
      request('DELETE', URI.encode("properties/#{id}/amenities/#{name}"))
    end

    def unpost_unit_amenity(id, name)
      request('DELETE', URI.encode("units/#{id}/amenities/#{name}"))
    end
  end
end
