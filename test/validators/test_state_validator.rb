require_relative '../helper'

class StateValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::StateValidator.new('California')
    refute v.valid?
    assert 'California is not a valid state', v.error

    v = Rentlinx::StateValidator.new('CA')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::StateValidator.new('CA')
    assert_equal 'CA', v.processed_value
  end
end
