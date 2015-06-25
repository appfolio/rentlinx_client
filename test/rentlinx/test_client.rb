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

  def test_204_does_not_json_parse
    use_vcr do
      assert_raises(NoMethodError) do
        Rentlinx::Property.from_id('test_204_does_not_json_parse')
      end
    end
  end

  def test_400_raises_bad_request
    use_vcr do
      assert_raises(Rentlinx::BadRequest) do
        Rentlinx::Client.new
      end
    end
  end

  def test_403_raises_forbidden
    use_vcr do
      assert_raises(Rentlinx::Forbidden) do
        Rentlinx::Client.new
      end
    end
  end

  def test_404_raises_not_found
    use_vcr do
      assert_raises(Rentlinx::NotFound) do
        Rentlinx::Client.new
      end
    end
  end

  def test_500_raises_server_error
    use_vcr do
      assert_raises(Rentlinx::ServerError) do
        Rentlinx::Client.new
      end
    end
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
end
