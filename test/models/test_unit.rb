require_relative '../helper'

class UnitTest < MiniTest::Test
  include SetupMethods

  def test_new
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)

    assert unit.valid?

    VALID_UNIT_ATTRS.each do |k, v|
      assert_equal v, unit.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    unit_params = { walkscore: '50505' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::Unit.new(unit_params)
    end
  end

  def test_unit_from_id
    use_vcr do
      unit = Rentlinx::Unit.from_id('test-unit-id')

      assert unit.valid?
      assert_equal 'test-unit-id', unit.unitID
    end
  end

  def test_valid__missing_required_params
    unit = Rentlinx::Unit.new({})
    assert !unit.valid?
  end

  def test_to_hash
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    hash = { propertyID: 'test-property-id', unitID: 'test-unit-id',
             isOpenToLease: true, name: 'My new unit',
             description: 'Fabulous unit on the ocean side', rent: '1600',
             maxRent: '', deposit: '3200', maxDeposit: '', squareFeet: '',
             bedrooms: '3', fullBaths: '2', halfBaths: '',
             isMobilityAccessible: '', isVisionAccessible: '',
             isHearingAccessible: '', rentIsBasedOnIncome: '',
             dateAvailable: '06/15/2015', dateLeasedThrough: '',
             numUnits: '', numAvailable: '', maxSquareFeet: '' }
    assert_equal hash, unit.to_hash
  end

  def test_unit_post_method_posts_and_updates
    use_vcr do
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.unitID = 'test_unit_post_method_posts_and_updates'
      unit.description = 'Hello this is mad dog'
      unit.post

      unit = Rentlinx::Unit.from_id('test_unit_post_method_posts_and_updates')

      assert_equal 'Hello this is mad dog', unit.description
      assert_equal 'test_unit_post_method_posts_and_updates', unit.unitID

      unit.description = 'This is the new description'
      unit.post

      unit = Rentlinx::Unit.from_id('test_unit_post_method_posts_and_updates')

      assert_equal 'This is the new description', unit.description
    end
  end

  def test_error_messages
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    assert unit.valid?

    unit.unitID = nil

    assert !unit.valid?
    expected = { unitID: 'is missing' }
    assert_equal expected, unit.validate
  end

  def test_unit_unpost_method
    use_vcr do
      property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      property.propertyID = 'test_unit_unpost_method__property2'
      property.post

      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.propertyID = property.propertyID
      unit.unitID = 'test_unit_unpost_method2'
      unit.post

      unit = Rentlinx::Unit.from_id(unit.unitID)
      unit.unpost

      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Unit.from_id('test_unit_unpost_method2')
      end
    end
  end

  def test_photos
    use_vcr do
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.unitID = 'test-photos-test'

      unit.photos = [Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)]
      unit.post_with_photos

      rl_unit = Rentlinx::Unit.from_id('test-photos-test')
      rl_unit.photos
      assert_equal 1, rl_unit.photos.size
      assert_equal unit.photos.first.url, rl_unit.photos.first.url
    end
  end

  def test_add_photo
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    unit.add_photo(url: 'http://asdf.com/wat.png', caption: 'this is a picture')
    assert 1, unit.photos.size
    assert_equal 'this is a picture', unit.photos.first.caption
    assert_equal unit.propertyID, unit.photos.first.propertyID
    assert_equal unit.unitID, unit.photos.first.unitID
  end

  def test_amenities
    use_vcr do
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.unitID = 'test-unit-amenities'

      unit.amenities = [Rentlinx::UnitAmenity.new(VALID_UNIT_AMENITY_ATTRS)]
      unit.post_with_amenities

      rl_unit = Rentlinx::Unit.from_id('test-unit-amenities')
      rl_unit.amenities
      assert_equal 1, rl_unit.amenities.size
      assert_equal 'No Dogs Allowed', unit.amenities.first.name
    end
  end

  def test_add_amenity
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    unit.add_amenity(name: '12 Months', details: 'We like long-term commitments')

    assert 1, unit.amenities.size
    assert_equal '12 Months', unit.amenities.first.name
    assert_equal 'We like long-term commitments', unit.amenities.first.details
    assert_equal unit.propertyID, unit.amenities.first.propertyID
    assert_equal unit.unitID, unit.amenities.first.unitID
  end

  def test_links
    use_vcr do
      unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
      unit.unitID = 'test-unit-links'

      unit.links = [Rentlinx::UnitLink.new(VALID_UNIT_LINK_ATTRS)]
      unit.post_with_links

      rl_unit = Rentlinx::Unit.from_id('test-unit-links')
      rl_unit.links
      assert_equal 1, rl_unit.links.size
      assert_equal 'Only You Can Prevent Wildfires!', unit.links.first.title
    end
  end

  def test_add_link
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    unit.add_link(title: '12 Months', url: 'http://www.youtube.com/')

    assert 1, unit.links.size
    assert_equal '12 Months', unit.links.first.title
    assert_equal 'http://www.youtube.com/', unit.links.first.url
    assert_equal unit.propertyID, unit.links.first.propertyID
    assert_equal unit.unitID, unit.links.first.unitID
  end
end
