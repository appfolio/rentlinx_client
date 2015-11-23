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
    v = Rentlinx::AmountValidator.new(BigDecimal.new('05.2'))
    assert v.valid?
    assert_equal BigDecimal, v.processed_value.class
    assert_equal '0.52E1', v.processed_value.to_s
  end
end
