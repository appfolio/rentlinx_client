require_relative '../helper'

class PropertyAmenityTest < MiniTest::Test
  include SetupMethods

  def test_new
    amenity = Rentlinx::PropertyAmenity.new(VALID_PROPERTY_AMENITY_ATTRS)

    assert amenity.valid?

    VALID_PROPERTY_AMENITY_ATTRS.each do |k, v|
      assert_equal v, amenity.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    amenity_params = { walkscore: '1234' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::PropertyAmenity.new(amenity_params)
    end
  end
end
