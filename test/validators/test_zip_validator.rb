require_relative '../helper'

class ZipValidatorTest < Minitest::Test
  def test_validate
    v = Rentlinx::ZipValidator.new('475888')
    refute v.valid?
    assert_equal '475888 is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)', v.error

    v = Rentlinx::ZipValidator.new('asdf1')
    refute v.valid?
    assert_equal 'asdf1 is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)', v.error

    v = Rentlinx::ZipValidator.new('93101')
    assert v.valid?

    v = Rentlinx::ZipValidator.new('93101-1234')
    assert v.valid?

    v = Rentlinx::ZipValidator.new('')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::ZipValidator.new('93101')
    assert_equal '93101', v.processed_value

    v = Rentlinx::ZipValidator.new('93101-1234')
    assert_equal '93101-1234', v.processed_value
  end
end
