require_relative '../helper'

class UnitPhotoTest < MiniTest::Test
  include SetupMethods

  def test_new
    photo = Rentlinx::UnitPhoto.new(VALID_UNIT_PHOTO_ATTRS)

    assert photo.valid?

    VALID_UNIT_PHOTO_ATTRS.each do |k, v|
      assert_equal v, photo.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    photo_params = { walkscore: '1234' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::UnitPhoto.new(photo_params)
    end
  end
end
