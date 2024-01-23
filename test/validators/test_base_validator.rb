require_relative '../helper'

class BaseValidatorTest < Minitest::Test
  def test_can_not_create_instance
    assert_raises(NameError) do
      Rentlinx::BaseValidator.new(1)
    end
  end
end
