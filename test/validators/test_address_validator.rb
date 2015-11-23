require_relative '../helper'

class AddressValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::AddressValidator.new('st')
    refute v.valid?
    assert_equal "'st' is not a valid address, an address must be 3 characters or more.", v.error

    v = Rentlinx::AddressValidator.new(nil)
    refute v.valid?
    assert_equal "'' is not a valid address, an address must be 3 characters or more.", v.error

    v = Rentlinx::AddressValidator.new('50 Castilian Dr.')
    assert v.valid?
  end

  def test_processed_value
    v = Rentlinx::AddressValidator.new('50 Castilian Dr.')
    assert_equal '50 Castilian Dr.', v.processed_value
  end
end
