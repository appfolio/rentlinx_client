require_relative '../helper'

class AttributeProcessorServiceTest < Minitest::Test
  def test_process_valid_attrs
    attrs = {
      phoneNumber: '+1 805-323-1212',
      state: 'CA',
      zip: '93117',
      randomField: 'a random field'
    }

    processor = Rentlinx::AttributeProcessor.new(attrs)
    processed_attrs = processor.process

    assert_equal '18053231212', processed_attrs[:phoneNumber]
    assert_equal 'CA', processed_attrs[:state]
    assert_equal 'a random field', processed_attrs[:randomField]
  end

  def test_process_invalid_attrs
    attrs = {
      phoneNumber: '+1 805-123-1212 0012',
      state: 'California',
      zip: 'whut'
    }

    processor = Rentlinx::AttributeProcessor.new(attrs)
    processor.process

    expected = { phoneNumber: '+1 805-123-1212 0012 is not a valid phone number',
                 state: 'California is not a valid state, states must be two characters (CA)',
                 zip: 'whut is not a valid zip code, zip codes must be five digits (93117) or five digits, a dash, and four digits (93117-1234)' }
    assert_equal expected, processor.errors
  end
end
