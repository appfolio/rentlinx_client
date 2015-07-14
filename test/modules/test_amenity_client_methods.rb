require_relative '../helper'

class AmenityClientMethodsTest < MiniTest::Test
  include SetupMethods

  def test_post_amenities_to_property
    use_vcr do
      assert_equal 0, Rentlinx.client.get_amenities_for_property_id(@prop.propertyID).size

      Rentlinx.client.post_amenities([@prop_amenity])

      new_amenities = Rentlinx.client.get_amenities_for_property_id(@prop.propertyID)
      assert_equal 1, new_amenities.size
      assert_equal @prop_amenity.propertyID, new_amenities.first.propertyID
      assert_equal @prop_amenity.details, new_amenities.first.details
      assert_equal @prop_amenity.name, new_amenities.first.name
    end
  end

  def test_get_amenities_for_property
    use_vcr do
      amenities = Rentlinx.client.get_amenities_for_property_id(@prop.propertyID)

      assert_equal 1, amenities.size
      assert_equal @prop_amenity.propertyID, amenities.first.propertyID
      assert_equal @prop_amenity.details, amenities.first.details
      assert_equal @prop_amenity.name, amenities.first.name
    end
  end

  def test_unpost_amenities_from_property
    use_vcr do
      amenities = Rentlinx.client.get_amenities_for_property_id(@prop.propertyID)
      assert_equal 1, amenities.size

      Rentlinx.client.unpost_amenity(@prop_amenity)

      unposted_amenities = Rentlinx.client.get_amenities_for_property_id(@prop.propertyID)
      assert_equal 0, unposted_amenities.size
    end
  end

  def test_post_amenities_to_unit
    use_vcr do
      assert_equal 0, Rentlinx.client.get_amenities_for_unit(@unit).size

      Rentlinx.client.post_amenities([@unit_amenity])

      new_amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 1, new_amenities.size
      assert_equal @unit_amenity.propertyID, new_amenities.first.propertyID
      assert_equal @unit_amenity.unitID, new_amenities.first.unitID
      assert_equal @unit_amenity.details, new_amenities.first.details
      assert_equal @unit_amenity.name, new_amenities.first.name
    end
  end

  def test_post_twice_the_same_amenity_does_not_add_it_twice
    use_vcr do
      assert_equal 0, Rentlinx.client.get_amenities_for_unit(@unit).size

      Rentlinx.client.post_amenities([@unit_amenity])
      Rentlinx.client.post_amenities([@unit_amenity])

      new_amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 1, new_amenities.size
    end
  end

  def test_get_amenities_for_unit
    use_vcr do
      amenities = Rentlinx.client.get_amenities_for_unit(@unit)

      assert_equal 1, amenities.size
      assert_equal amenities.first.class, Rentlinx::UnitAmenity
      assert_equal @unit_amenity.propertyID, amenities.first.propertyID
      assert_equal @unit_amenity.unitID, amenities.first.unitID
      assert_equal @unit_amenity.details, amenities.first.details
      assert_equal @unit_amenity.name, amenities.first.name
    end
  end

  def test_unpost_amenities_from_unit
    use_vcr do
      amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 1, amenities.size

      Rentlinx.client.unpost_amenity(@unit_amenity)

      unposted_amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 0, unposted_amenities.size
    end
  end

  def test_post_invalid_amenity_raises_an_exception
    use_vcr do
      invalid_amenity = Rentlinx::UnitAmenity.new(unitID: @unit.unitID, name: 'No Dogs Allowed')
      assert_raises(Rentlinx::InvalidObject) do
        Rentlinx.client.post_amenities([invalid_amenity])
      end
    end
  end

  def test_post_amenity_name_gets_escaped
    use_vcr do
      amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 1, amenities.size

      amenity = Rentlinx::UnitAmenity.new(unitID: @unit.unitID, propertyID: @unit.propertyID, name: 'Washer & Dryer On-Site')
      Rentlinx.client.post_amenities([amenity])

      new_amenities = Rentlinx.client.get_amenities_for_unit(@unit)
      assert_equal 2, new_amenities.size
    end
  end

  def setup
    super

    @prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    @prop.propertyID = 'test_post_amenity_property'

    @unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    @unit.propertyID = @prop.propertyID
    @unit.unitID = 'test_post_amenity_unit'

    @prop_amenity = Rentlinx::PropertyAmenity.new(VALID_PROPERTY_AMENITY_ATTRS.merge(propertyID: @prop.propertyID))
    @unit_amenity = Rentlinx::UnitAmenity.new(VALID_UNIT_AMENITY_ATTRS.merge(propertyID: @prop.propertyID, unitID: @unit.unitID))
  end
end