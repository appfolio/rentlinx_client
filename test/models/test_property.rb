require_relative '../helper'

class PropertyTest < Minitest::Test
  include SetupMethods

  def test_new
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)

    assert property.valid?

    VALID_PROPERTY_ATTRS.each do |k, v|
      next if k == :phoneNumber
      assert_equal v, property.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    property_params = { walkscore: '50505' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::Property.new(property_params)
    end
  end

  def test_new__does_not_mutate
    attrs = {
      phoneNumber: '(818) 703 2087'
    }

    old_attrs = attrs.dup

    Rentlinx::Property.new(attrs)

    assert_equal old_attrs, attrs
  end

  def test_property_from_id
    use_vcr do
      prop = Rentlinx::Property.from_id('test-property-id')

      assert prop.valid?
      assert_equal 'test-property-id', prop.propertyID
    end
  end

  def test_valid__missing_required_params
    property_params = {}
    property = Rentlinx::Property.new(property_params)
    assert !property.valid?
  end

  def test_to_hash
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    hash = { companyID: 'test-company-id', propertyID: 'test-property-id',
             description: 'This is a test property.', address: '55 Castilian',
             city: 'Santa Barbara', state: 'CA', zip: '93117',
             phoneNumber: '8054523214',
             emailAddress: 'support@appfolio.com',
             companyName: 'test company', rentlinxID: 54_321 }
    assert_equal hash, property.to_hash
  end

  def test_property_post_method_posts_and_updates
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_property_post_method_posts_and_updates'
      prop.marketingName = 'Hello this is mad dog'
      prop.post

      prop = Rentlinx::Property.from_id('test_property_post_method_posts_and_updates')

      assert_equal 'Hello this is mad dog', prop.marketingName
      assert_equal 'test_property_post_method_posts_and_updates', prop.propertyID
      assert_equal 'This is a test property.', prop.description

      prop.description = 'This is the new description'
      prop.post

      prop = Rentlinx::Property.from_id('test_property_post_method_posts_and_updates')

      assert_equal 'This is the new description', prop.description
    end
  end

  def test_property_patch_method
    use_vcr do
      h = {
        propertyID: 'test-property-id',
        address: '55 Castilian',
        city: 'Santa Barbara',
        state: 'CA',
        zip: '93117',
        phoneNumber: '(805) 452-3214',
        emailAddress: 'support@appfolio.com'
      }
      prop = Rentlinx::Property.new(h)
      prop.post

      h2 = {
        propertyID: 'test-property-id',
        premium: true,
        capAmount: BigDecimal('100.00')
      }
      prop2 = Rentlinx::Property.new(h2)
      prop2.patch
    end
  end

  def test_units
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_units_property'
      prop.units = [Rentlinx::Unit.new(unitID: 'test_units_unit_1'),
                    Rentlinx::Unit.new(unitID: 'test_units_unit_2'),
                    Rentlinx::Unit.new(unitID: 'test_units_unit_3')]

      assert_equal 3, prop.units.count

      prop.post_with_units

      remote_prop = Rentlinx::Property.from_id('test_units_property')

      assert_equal 3, remote_prop.units.count
      assert_equal 'test_units_unit_1', remote_prop.units.first.unitID
    end
  end

  def test_error_messages
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    assert prop.valid?

    prop.propertyID = nil
    prop.address = nil

    assert !prop.valid?
    expected_errors = {
      propertyID: 'is missing',
      address: 'is missing'
    }
    assert_equal expected_errors, prop.validate
  end

  def test_error_messages__invalid_phone
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    assert prop.valid?

    prop.phoneNumber = '3'
    assert !prop.valid?
    expected_errors = { phoneNumber: '3 is not a valid phone number' }
    assert_equal expected_errors, prop.validate

    prop.phoneNumber = '33413412341234123412344123412341240'
    assert !prop.valid?
    expected_errors = { phoneNumber: '33413412341234123412344123412341240 is not a valid phone number' }
    assert_equal expected_errors, prop.validate

    prop.phoneNumber = '7032087'
    assert !prop.valid?
    expected_errors = { phoneNumber: '7032087 is not a valid phone number' }
    assert_equal expected_errors, prop.validate

    prop.phoneNumber = '1111111111'
    assert !prop.valid?
    expected_errors = { phoneNumber: '1111111111 is not a valid phone number' }
    assert_equal expected_errors, prop.validate
  end

  def test_error_messages_invalid_state
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    assert prop.valid?

    prop.state = 'Merica'
    assert !prop.valid?
    expected_errors = { state: 'Merica is not a valid state, states must be two characters (CA)' }
    assert_equal expected_errors, prop.validate

    prop.state = '49'
    assert !prop.valid?
    expected_errors = { state: '49 is not a valid state, states must be two characters (CA)' }
    assert_equal expected_errors, prop.validate

    prop.state = 'CA'
    assert prop.valid?
    expected_errors = {}
    assert_equal expected_errors, prop.validate

    prop.state = 'ny'
    assert prop.valid?
    expected_errors = {}
    assert_equal expected_errors, prop.validate

    prop.state = 'WW'
    assert !prop.valid?
    expected_errors = { state: 'WW is not a valid state, states must be two characters (CA)' }
    assert_equal expected_errors, prop.validate
  end

  def test_error_messages_invalid_zip
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    assert prop.valid?

    prop.zip = '3'
    assert !prop.valid?
    expected_errors = { zip: '3 is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)' }
    assert_equal expected_errors, prop.validate

    prop.zip = '314159'
    assert !prop.valid?
    expected_errors = { zip: '314159 is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)' }
    assert_equal expected_errors, prop.validate

    prop.zip = '91304'
    assert prop.valid?
    expected_errors = {}
    assert_equal expected_errors, prop.validate
  end

  def test_class_unpost
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_class_unpost'
      prop.post

      Rentlinx::Property.unpost('test_class_unpost')

      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Property.from_id('test_class_unpost')
      end
    end
  end

  def test_unpost
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_4123434124'
      prop.post

      prop = Rentlinx::Property.from_id('test_4123434124')

      prop.unpost

      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Property.from_id('test_4123434124')
      end
    end
  end

  def test_photos
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test-photos-test'

      prop.photos = [Rentlinx::PropertyPhoto.new(VALID_PROPERTY_PHOTO_ATTRS)]
      prop.post_with_photos

      rl_prop = Rentlinx::Property.from_id('test-photos-test')
      rl_prop.photos
      assert_equal 1, rl_prop.photos.size
      assert_equal prop.photos.first.url, rl_prop.photos.first.url
    end
  end

  def test_add_photo
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    prop.add_photo(url: 'http://asdf.com/wat.png', caption: 'this is a picture')
    assert_equal 1, prop.photos.size
    assert_equal 'this is a picture', prop.photos.first.caption
    assert_equal prop.propertyID, prop.photos.first.propertyID
  end

  def test_amenities
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test-property-amenities'

      prop.amenities = [Rentlinx::PropertyAmenity.new(VALID_PROPERTY_AMENITY_ATTRS)]
      prop.post_with_amenities

      rl_prop = Rentlinx::Property.from_id('test-property-amenities')
      rl_prop.amenities
      assert_equal 1, rl_prop.amenities.size
      assert_equal prop.amenities.first.name, 'Garbage Disposal'
    end
  end

  def test_add_amenity
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    prop.add_amenity(name: '12 Months', details: 'We like long-term commitments')

    assert_equal 1, prop.amenities.size
    assert_equal '12 Months', prop.amenities.first.name
    assert_equal 'We like long-term commitments', prop.amenities.first.details
    assert_equal prop.propertyID, prop.amenities.first.propertyID
  end

  def test_links
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test-property-links'

      prop.links = [Rentlinx::PropertyLink.new(VALID_PROPERTY_LINK_ATTRS)]
      prop.post_with_links

      rl_prop = Rentlinx::Property.from_id('test-property-links')
      rl_prop.links
      assert_equal 1, rl_prop.links.size
      assert_equal prop.links.first.title, 'Ring ding'
    end
  end

  def test_add_link
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    prop.add_link(title: '12 Months', url: 'http://www.youtube.com/')

    assert_equal 1, prop.links.size
    assert_equal '12 Months', prop.links.first.title
    assert_equal 'http://www.youtube.com/', prop.links.first.url
    assert_equal prop.propertyID, prop.links.first.propertyID
  end

  def test_websites
    Rentlinx::Client.any_instance.expects(:get_websites).with('test-id').returns('data' => [])
    Rentlinx::Property.websites('test-id')
  end
end
