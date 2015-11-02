require_relative '../helper'

class AmountValidatorTest < MiniTest::Test
  def test_validate__invalid
    v = Rentlinx::AmountValidator.new(nil)
    refute v.valid?
    assert_equal "'' is not a valid amount.", v.error

    v = Rentlinx::AmountValidator.new('')
    refute v.valid?
    assert_equal "'' is not a valid amount.", v.error

    v = Rentlinx::AmountValidator.new('st')
    refute v.valid?
    assert_equal "'st' is not a valid amount.", v.error
  end

  def test_validate__valid
    v = Rentlinx::AmountValidator.new('050')
    assert v.valid?
    assert '50', v.processed_value

    v = Rentlinx::AmountValidator.new('50')
    assert v.valid?
    assert '50', v.processed_value

    v = Rentlinx::AmountValidator.new('50.0')
    assert v.valid?
    assert '50.0', v.processed_value

    v = Rentlinx::AmountValidator.new('50.01')
    assert v.valid?
    assert '50.01', v.processed_value

    v = Rentlinx::AmountValidator.new('100.00')
    assert v.valid?
    assert '100.00', v.processed_value
  end
end
