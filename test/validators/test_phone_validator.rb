require_relative '../helper'

class PhoneValidatorTest < MiniTest::Test
  def test_valid_phone_numbers
    valid_numbers = [
      '+1-805-555-5555',
      '(866) 648-1536',
      '(805) 452-3214',
      '1 (866) 648-1536',
      '+1 (866) 648-1536',
      '18666481536',
      '8666481536',
      '3106481536'
    ]

    valid_numbers.each do |num|
      assert Rentlinx::PhoneValidator.new(num).valid?, "#{num} should be considered valid"
    end
  end

  def test_invalid_phone_numbers
    invalid_numbers = [
      'As a user, I have no idea what phone numbers are or even what they should look like, so that I can make engineers lives harder.',
      'info@appfolio.com',
      '(209) 368-5554 extension 103 edie or eileen',
      '615-255-2703 x 13',
      '858-675-9515 bre#01255583',
      '855 48 home 4',
      '(619)223-rent(7368)',
      '(619)223-rent',
      'office: 615-255-2703, after hours: 858-675-9515',
      '615-255-2703,858-675-9515',
      '412341234123124',
      '1187032087',
      '(619) 123-4567',
      '+11 (987) 723 8325'
    ]

    invalid_numbers.each do |num|
      refute Rentlinx::PhoneValidator.new(num).valid?, "#{num} should not be considered valid"
    end
  end

  def test_adds_error_message
    v = Rentlinx::PhoneValidator.new('+112217 27 7 83')
    assert_equal '+112217 27 7 83 is not a valid phone number', v.error
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

  def test_with_number_phony_thinks_is_invalid
    # Phony will strip the zero out of this phone number :(
    v = Rentlinx::PhoneValidator.new('3105555555')
    assert v.valid?
    assert_equal '3105555555', v.processed_value
  end
end
