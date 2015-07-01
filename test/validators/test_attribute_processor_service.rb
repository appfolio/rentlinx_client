require_relative '../helper'

class AttributeProcessorServiceTest < MiniTest::Test
  def test_process_valid_attrs
    attrs = {
      phoneNumber: '+1 805-123-1212',
      state: 'CA',
      randomField: 'a random field'
    }

    processor = Rentlinx::AttributeProcessor.new(attrs)
    processed_attrs = processor.process

    assert_equal '18051231212', processed_attrs[:phoneNumber]
    assert_equal 'CA', processed_attrs[:state]
    assert_equal 'a random field', processed_attrs[:randomField]
  end

  def test_process_invalid_attrs
    attrs = {
      phoneNumber: '+1 805-123-1212 0012',
      state: 'California'
    }

    processor = Rentlinx::AttributeProcessor.new(attrs)
    processor.process

    t = { phoneNumber: '+1 805-123-1212 0012 is not a valid phone number', state: 'California is not a valid state' }
    assert_equal t, processor.errors
  end
end
