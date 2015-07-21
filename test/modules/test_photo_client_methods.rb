require_relative '../helper'

class PhotoClientMethodsTest < MiniTest::Test
  include SetupMethods

  def test_post_photos
    prop_photo = Rentlinx::PropertyPhoto.new(VALID_PROPERTY_PHOTO_ATTRS)
    unit_photo = Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)
    unit_photo2 = Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)
    unit_photo2.unitID = 'test-unit-two'
    unit_photo3 = Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)
    unit_photo3.unitID = 'test-unit-three'

    use_vcr do
      Rentlinx.client.post_photos([prop_photo, unit_photo, unit_photo2, unit_photo3])

      photos = Rentlinx.client.get_photos_for_property_id('test-property-id')
      assert_equal 4, photos.count
      assert_equal 1, photos.count { |p| p.class == Rentlinx::PropertyPhoto }
      assert_equal 3, photos.count { |p| p.class == Rentlinx::UnitPhoto }
      assert_equal 1, photos.map(&:propertyID).uniq.compact.count
      assert_equal 4, photos.map(&:unitID).uniq.count
      assert_equal [prop_photo, unit_photo, unit_photo2, unit_photo3].map(&:url).sort, photos.map(&:url).sort
    end
  end

  def test_get_photos_for_property
    use_vcr do
      photos = Rentlinx.client.get_photos_for_property_id('test-property-id')
      assert_equal 4, photos.size
    end
  end

  def test_unpost_photos
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_unpost_photos_property'
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.propertyID = 'test_unpost_photos_property'
      unit.unitID = 'test_unpost_photos_unit'

      prop_photo = Rentlinx::PropertyPhoto.new(VALID_PROPERTY_PHOTO_ATTRS)
      prop_photo.propertyID = prop.propertyID
      prop_photo.url = 'https://upload.wikimedia.org/wikipedia/commons/f/fb/General_John_Shalikashvili_military_portrait,_1993.JPEG'

      unit_photo = Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)
      unit_photo.propertyID = prop.propertyID
      unit_photo.unitID = unit.unitID
      unit_photo.url = 'http://img2.wikia.nocookie.net/__cb20120412095514/hitlerparody/images/2/27/897945-general-aladeen.jpg'

      prop.post
      unit.post
      Rentlinx.client.post_photos([prop_photo, unit_photo])

      photos = Rentlinx.client.get_photos_for_property_id(prop.propertyID)
      assert_equal 2, photos.size

      Rentlinx.client.unpost_photo(prop_photo)
      unposted_photos = Rentlinx.client.get_photos_for_property_id(prop.propertyID)
      assert_equal 1, unposted_photos.size

      Rentlinx.client.unpost_photo(unit_photo)
      unposted_photos = Rentlinx.client.get_photos_for_property_id(prop.propertyID)
      assert_equal 0, unposted_photos.size
    end
  end
end
