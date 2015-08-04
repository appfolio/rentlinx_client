require_relative '../helper'

class LinkClientMethodsTest < MiniTest::Test
  include SetupMethods

  def test_post_links_to_property
    use_vcr do
      assert_equal 0, Rentlinx.client.get_links_for_property_id(@prop.propertyID).size

      Rentlinx.client.post_links([@prop_link])

      new_links = Rentlinx.client.get_links_for_property_id(@prop.propertyID)
      assert_equal 1, new_links.size
      assert_equal @prop_link.propertyID, new_links.first.propertyID
      assert_equal @prop_link.title, new_links.first.title
      assert_equal @prop_link.url, new_links.first.url
    end
  end

  def test_get_links_for_property
    use_vcr do
      links = Rentlinx.client.get_links_for_property_id(@prop.propertyID)

      assert_equal 1, links.size
      assert_equal @prop_link.propertyID, links.first.propertyID
      assert_equal @prop_link.title, links.first.title
      assert_equal @prop_link.url, links.first.url
    end
  end

  def test_unpost_links_from_property
    use_vcr do
      links = Rentlinx.client.get_links_for_property_id(@prop.propertyID)
      assert_equal 1, links.size

      Rentlinx.client.unpost_link(@prop_link)

      unposted_links = Rentlinx.client.get_links_for_property_id(@prop.propertyID)
      assert_equal 0, unposted_links.size
    end
  end

  def test_post_links_to_unit
    use_vcr do
      assert_equal 0, Rentlinx.client.get_links_for_unit(@unit).size

      Rentlinx.client.post_links([@unit_link])

      new_links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 1, new_links.size
      assert_equal @unit_link.propertyID, new_links.first.propertyID
      assert_equal @unit_link.unitID, new_links.first.unitID
      assert_equal @unit_link.title, new_links.first.title
      assert_equal @unit_link.url, new_links.first.url
    end
  end

  def test_get_links_for_unit
    use_vcr do
      links = Rentlinx.client.get_links_for_unit(@unit)

      assert_equal 1, links.size
      assert_equal links.first.class, Rentlinx::UnitLink
      assert_equal @unit_link.propertyID, links.first.propertyID
      assert_equal @unit_link.unitID, links.first.unitID
      assert_equal @unit_link.title, links.first.title
      assert_equal @unit_link.url, links.first.url
    end
  end

  def test_post_link_title_gets_escaped
    use_vcr do
      links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 0, links.size

      link = Rentlinx::UnitLink.new(unitID: @unit.unitID, propertyID: @unit.propertyID, url: 'http://www.appfolio.com', title: 'D@pper Duck & Gilly the Goose')
      Rentlinx.client.post_links([link])

      new_links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 1, new_links.size
    end
  end

  def test_unpost_links_from_unit
    use_vcr do
      Rentlinx.client.post_links([@unit_link])

      links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 1, links.size

      Rentlinx.client.unpost_link(@unit_link)

      unposted_links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 0, unposted_links.size
    end
  end

  def test_post_twice_the_same_link_does_not_add_it_twice
    use_vcr do
      assert_equal 0, Rentlinx.client.get_links_for_unit(@unit).size

      Rentlinx.client.post_links([@unit_link])
      Rentlinx.client.post_links([@unit_link])

      new_links = Rentlinx.client.get_links_for_unit(@unit)
      assert_equal 1, new_links.size
    end
  end

  def test_post_invalid_link_raises_an_exception
    use_vcr do
      invalid_link = Rentlinx::UnitLink.new(unitID: @unit.unitID, url: 'I am not a URL!')
      assert_raises(Rentlinx::InvalidObject) do
        Rentlinx.client.post_links([invalid_link])
      end
    end
  end

  def setup
    super

    @prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    @prop.propertyID = 'test_post_link_property'

    @unit = Rentlinx::Unit.new(VALID_UNIT_ATTRS)
    @unit.propertyID = @prop.propertyID
    @unit.unitID = 'test_post_link_unit'

    @prop_link = Rentlinx::PropertyLink.new(VALID_PROPERTY_LINK_ATTRS.merge(propertyID: @prop.propertyID))
    @unit_link = Rentlinx::UnitLink.new(VALID_UNIT_LINK_ATTRS.merge(propertyID: @prop.propertyID, unitID: @unit.unitID))
  end
end
