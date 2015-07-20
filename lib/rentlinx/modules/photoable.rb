module Rentlinx
  module Photoable
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
        photo.unitID = unitID if defined? unitID
        photo
      end
    end

    def add_photo(options)
      options.merge!(propertyID: propertyID)
      options.merge!(unitID: unitID) if defined? unitID
      @photos ||= []
      @photos << photo_class.new(options)
    end

    private

    def get_photos_for_property_id(id)
      Rentlinx.client.get_photos_for_property_id(id)
    end
  end
end
