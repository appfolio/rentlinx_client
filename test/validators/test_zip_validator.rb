require_relative '../helper'

class ZipValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::ZipValidator.new('475888')
    refute v.valid?
    assert_equal '475888 is not a valid zip code, zip codes must be five digits (93117)', v.error

    v = Rentlinx::ZipValidator.new('asdf1')
    refute v.valid?

    v = Rentlinx::ZipValidator.new('93101')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::StateValidator.new('CA')
    assert_equal 'CA', v.processed_value
  end
end
