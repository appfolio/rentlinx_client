require_relative '../helper'

class UnitAmenityTest < MiniTest::Test
  include SetupMethods

  def test_new
    amenity = Rentlinx::UnitAmenity.new(VALID_UNIT_AMENITY_ATTRS)

    assert amenity.valid?

    VALID_UNIT_AMENITY_ATTRS.each do |k, v|
      assert_equal v, amenity.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    amenity_params = { walkscore: '1234' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::UnitAmenity.new(amenity_params)
    end
  end
end
