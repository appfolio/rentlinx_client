module Rentlinx
  # A module that encapsulates all photo related logic for {Rentlinx::Property} and
  # {Rentlinx::Unit} objects. All of these methods can be called on Properties and Units.
  #
  # TODO: Refactor into BaseAble class along with {Linkable} and {Amenityable}
  module Photoable
    def post_with_photos
      post
      post_photos
    end

    def post_photos
      return if @photos.nil?

      if @photos.empty?
        Rentlinx.client.unpost_photos_for(self)
      else
        Rentlinx.client.post_photos(@photos)
      end
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
      options[:propertyID] = propertyID
      options[:unitID] = unitID if defined? unitID
      @photos ||= []
      @photos << photo_class.new(options)
    end

    private

    def get_photos_for_property_id(id)
      Rentlinx.client.get_photos_for_property_id(id)
    end
  end
end
