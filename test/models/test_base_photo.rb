require_relative '../helper'

class PhotoTest < MiniTest::Test
  include SetupMethods

  def test_new
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::BasePhoto.new(fakeParam: '1234')
    end
  end
end
