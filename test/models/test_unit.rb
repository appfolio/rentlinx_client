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

  def test_valid_for_post
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)

    assert unit.valid?
    assert unit.valid_for_post?

    unit.propertyID = nil

    assert unit.valid?
    assert !unit.valid_for_post?
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

  def test_missing_attributes
    unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    assert unit.valid?

    unit.unitID = nil

    assert !unit.valid?
    assert_equal 'Missing required attributes: unitID', unit.missing_attributes
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
end
