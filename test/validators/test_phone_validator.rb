require_relative '../helper'

class PhoneValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::PhoneValidator.new('+112217 27 7 83')
    refute v.valid?
    assert_equal '+112217 27 7 83 is not a valid phone number', v.error

    v = Rentlinx::PhoneValidator.new('+1-805-555-5555')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::PhoneValidator.new('(818) 805-2262')
    assert_equal '8188052262', v.processed_value
  end

  def test_with_blank_value
    v = Rentlinx::PhoneValidator.new('')
    assert_equal '', v.processed_value

    v = Rentlinx::PhoneValidator.new(nil)
    assert_equal '', v.processed_value
  end
end
