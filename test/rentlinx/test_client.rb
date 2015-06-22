require_relative '../helper'

class ClientTest < MiniTest::Test
  include SetupMethods

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
end
