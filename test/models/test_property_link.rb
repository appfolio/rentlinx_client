require_relative '../helper'

class PropertyLinkTest < MiniTest::Test
  include SetupMethods

  def test_new
    link = Rentlinx::PropertyLink.new(VALID_PROPERTY_LINK_ATTRS)

    assert link.valid?

    VALID_PROPERTY_LINK_ATTRS.each do |k, v|
      assert_equal v, link.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    link_params = { walkscore: '1234' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::PropertyLink.new(link_params)
    end
  end
end
