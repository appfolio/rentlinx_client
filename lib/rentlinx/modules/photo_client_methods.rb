module Rentlinx
  # Client methods for photos
  #
  # TODO: Refactor into AttachmentClientMethods
  module PhotoClientMethods
    def post_photos(photos)
      return if photos.nil?
      raise(Rentlinx::InvalidObject, photos.find { |p| !p.valid? }) unless photos.all?(&:valid?)
      raise(Rentlinx::IncompatibleGroupOfObjectsForPost, 'propertyID') unless photos.all? { |p| p.propertyID == photos.first.propertyID }

      property_photos = photos.select { |p| p.class == Rentlinx::PropertyPhoto }
      unit_photos = photos - property_photos

      post_property_photos(property_photos) unless property_photos.empty?
      post_unit_photos(unit_photos) unless unit_photos.empty?
    end

    def unpost_photos_for(object)
      case object
      when Rentlinx::Unit
        post_photos_for_unit_id(object.unitID, [])
      when Rentlinx::Property
        post_photos_for_property_id(object.propertyID, [])
      else
        raise TypeError, "Type not permitted: #{object.class}"
      end
    end

    def get_photos_for_property_id(id)
      data = request('GET', "properties/#{id}/photos")['data']
      data.map do |photo_data|
        if photo_data['unitID'].nil? || photo_data['unitID'] == ''
          photo_data.delete('unitID')
          PropertyPhoto.new(symbolize_data(photo_data))
        else
          UnitPhoto.new(symbolize_data(photo_data))
        end
      end
    end

    def unpost_photo(photo)
      case photo
      when Rentlinx::UnitPhoto
        unpost_unit_photo(photo.unitID, photo.url)
      when Rentlinx::PropertyPhoto
        unpost_property_photo(photo.propertyID, photo.url)
      else
        raise TypeError, "Invalid type: #{photo.class}"
      end
    end

    private

    # post_photos should only be called from property or unit, so we don't need
    # to handle multiple properties
    def post_property_photos(photos)
      post_photos_for_property_id(photos.first.propertyID, photos)
    end

    def post_photos_for_property_id(id, photos)
      request('PUT', "properties/#{id}/photos", photos.map(&:to_hash))
    end

    def post_unit_photos(photos)
      hash = {}
      photos.each do |p|
        if hash.keys.include?(p.unitID)
          hash[p.unitID] << p
        else
          hash[p.unitID] = [p]
        end
      end

      hash.each do |unit_id, unit_photos|
        post_photos_for_unit_id(unit_id, unit_photos)
      end
    end

    def post_photos_for_unit_id(id, photos)
      request('PUT', "units/#{id}/photos", photos.map(&:to_hash))
    end

    def unpost_property_photo(id, url)
      request('DELETE', "properties/#{id}/photos", url: url)
    end

    def unpost_unit_photo(id, url)
      request('DELETE', "units/#{id}/photos", url: url)
    end
  end
end
