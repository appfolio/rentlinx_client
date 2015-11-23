require_relative '../helper'

class CityValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::CityValidator.new('LA')
    refute v.valid?
    assert_equal "'LA' is not a valid city, a city must be 3 characters or more.", v.error

    v = Rentlinx::CityValidator.new(nil)
    refute v.valid?
    assert_equal "'' is not a valid city, a city must be 3 characters or more.", v.error

    v = Rentlinx::CityValidator.new('Los Angeles')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::CityValidator.new('Los Angeles')
    assert_equal 'Los Angeles', v.processed_value
  end
end
