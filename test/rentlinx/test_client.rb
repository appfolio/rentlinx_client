require_relative '../helper'

class ClientTest < MiniTest::Test
  include SetupMethods

  def test_initialize
    use_vcr do
      Rentlinx::Client.new
    end
  end

  def test_initialize_not_configured
    Rentlinx.configure do |rentlinx|
      rentlinx.username nil
    end

    assert_raises(Rentlinx::NotConfigured) do
      Rentlinx::Client.new
    end

  ensure
    Rentlinx.configure do |rentlinx|
      rentlinx.username ENV['RENTLINX_USERNAME'] || '<USERNAME>'
    end
  end

  def test_post_with_property
    use_vcr do
      property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      client = Rentlinx::Client.new
      client.post(property)
    end
  end

  def test_post_with_unit
    use_vcr do
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      client = Rentlinx::Client.new
      client.post(unit)
    end
  end

  def test_unpost_with_property
    use_vcr do
      property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      property.propertyID = 'test_unpost_with_property'
      property.post

      client = Rentlinx::Client.new
      client.unpost(:property, property.propertyID)

      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Property.from_id('test_unpost_with_property')
      end
    end
  end

  def test_unpost_with_unit
    use_vcr do
      property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      property.propertyID = 'test_unpost_with_unit_property'
      property.post

      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.propertyID = property.propertyID
      unit.unitID = 'test_unpost_with_unit_unit'
      unit.post

      client = Rentlinx::Client.new
      client.unpost(:unit, unit.unitID)

      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Unit.from_id('test_unpost_with_unit_unit')
      end
    end
  end

  def test_post__invalid_object
    use_vcr do
      client = Rentlinx::Client.new

      assert_raises(TypeError) { client.post(1234) }
    end
  end

  def test_get_property
    use_vcr do
      client = Rentlinx::Client.new

      prop = client.get(:property, 'test-property-id')

      assert prop.valid?
      assert_equal 'test-property-id', prop.propertyID
    end
  end

  def test_get_unit
    use_vcr do
      client = Rentlinx::Client.new

      unit = client.get(:unit, 'test-unit-id')

      assert unit.valid?
      assert_equal 'test-unit-id', unit.unitID
    end
  end

  def test_get__invalid_type
    use_vcr do
      client = Rentlinx::Client.new

      assert_raises(Rentlinx::InvalidTypeParam) { client.get(:space_ship, 1) }
    end
  end

  def test_get_units_for_property_id
    use_vcr do
      client = Rentlinx::Client.new
      units = client.get_units_for_property_id('test-property-id')

      assert_equal 2, units.count
      assert_equal Rentlinx::Unit, units.first.class
    end
  end

  def test_204_does_not_json_parse
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_204_does_not_json_parse'
      prop.post

      # JSON should not be asked to parse the response of the delete action
      JSON.expects(:parse).never

      assert prop.unpost.nil?
    end
  end

  def test_400_raises_bad_request
    request_mock = mock
    request_mock.expects(:status).returns(400)
    request_mock.expects(:body).returns({ details: 'There was an error.' }.to_json)
    HTTPClient.any_instance.expects(:request).returns(request_mock)

    assert_raises(Rentlinx::BadRequest) do
      Rentlinx::Client.new
    end
  end

  def test_http_errors_are_httperrors
    response_stub(500, Rentlinx::HTTPError)
  end

  def test_403_raises_forbidden
    response_stub(403, Rentlinx::Forbidden)
  end

  def test_404_raises_not_found
    response_stub(404, Rentlinx::NotFound)
  end

  def test_500_raises_server_error
    response_stub(500, Rentlinx::ServerError)
  end

  def test_unhandled_response_code_raises_http_error
    response_stub(100, Rentlinx::HTTPError)
  end

  def test_invalid_object
    use_vcr do
      assert_raises(Rentlinx::InvalidObject) do
        Rentlinx::Property.new({}).post
      end

      assert_raises(Rentlinx::InvalidObject) do
        Rentlinx::Unit.new({}).post
      end
    end
  end

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
      assert_equal 1, photos.count { |p| p.is_a? Rentlinx::PropertyPhoto }
      assert_equal 3, photos.count { |p| p.is_a? Rentlinx::UnitPhoto }
      assert_equal 1, photos.map(&:propertyID).uniq.compact.count
      assert_equal 4, photos.map(&:unitID).uniq.count
      assert_equal [prop_photo, unit_photo, unit_photo2, unit_photo3].map(&:url).sort, photos.map(&:url).sort
    end
  end

  def test_get_photos_for_properties
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
      Rentlinx.client.unpost_photo(unit_photo)

      unposted_photos = Rentlinx.client.get_photos_for_property_id(prop.propertyID)
      puts unposted_photos.inspect
      assert_equal 0, unposted_photos.size
    end
  end

  private

  def response_stub(status_code, error_class)
    request_mock = mock
    request_mock.expects(:status).returns(status_code)
    HTTPClient.any_instance.expects(:request).returns(request_mock)

    assert_raises(error_class) do
      Rentlinx::Client.new
    end
  end
end
