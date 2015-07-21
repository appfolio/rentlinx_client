require_relative '../helper'

class BaseTest < MiniTest::Test
  def test_new
    assert_raises(NameError) do
      Rentlinx::Base.new(fakeParam: '1234')
    end
  end
end
