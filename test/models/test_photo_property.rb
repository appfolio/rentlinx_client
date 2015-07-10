require_relative '../helper'

class PropertyPhotoTest < MiniTest::Test
  include SetupMethods

  def test_new
    photo = Rentlinx::PropertyPhoto.new(VALID_PROPERTY_PHOTO_ATTRS)

    assert photo.valid?

    VALID_PROPERTY_PHOTO_ATTRS.each do |k, v|
      assert_equal v, photo.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    photo_params = { walkscore: '1234' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::PropertyPhoto.new(photo_params)
    end
  end
end
