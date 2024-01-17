require_relative '../helper'

class LinkClientMethodsTest < Minitest::Test
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

  def test_post_links__with_empty_array_unpost_unit_links
    use_vcr do
      assert_equal 0, Rentlinx.client.get_links_for_unit(@unit).size

      @unit.links = [@unit_link]
      @unit.post_links

      assert_equal 1, Rentlinx.client.get_links_for_unit(@unit).size

      @unit.links = []
      @unit.post_links

      assert_equal 0, Rentlinx.client.get_links_for_unit(@unit).size
    end
  end

  def test_post_links__with_empty_array_unpost_property_links
    use_vcr do
      assert_equal 0, Rentlinx.client.get_links_for_property_id(@prop.propertyID).size

      Rentlinx.client.post_links([@prop_link])

      assert_equal 1, Rentlinx.client.get_links_for_property_id(@prop.propertyID).size

      @prop.links = []
      @prop.post_links

      assert_equal 0, Rentlinx.client.get_links_for_property_id(@prop.propertyID).size
    end
  end

  def test_post_links__nil_does_not_post
    prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    prop.propertyID = 'test_post_links_nil_property'
    Rentlinx::Client.any_instance.expects(:post_links).never
    Rentlinx::Client.any_instance.expects(:post_property_links).never

    use_vcr do
      prop.post_links
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

      assert_unit_links_equal @unit_link, Rentlinx.client.get_links_for_unit(@unit)
    end
  end

  def test_get_links_for_unit
    use_vcr do
      links = Rentlinx.client.get_links_for_unit(@unit)

      assert_unit_links_equal @unit_link, links
    end
  end

  def test_get_links_for_unit__only_gets_for_unit
    use_vcr do
      unit2 = @unit.dup

      @unit.unitID = 'test_get_links_for_unit__only_gets_for_unit'
      @unit.post
      @unit.links = [@unit_link]
      @unit.post_with_links

      # New unit on the same property
      unit2.unitID = 'test_get_links_for_unit__only_gets_for_unit_2'
      unit2.add_link(title: 'Test Link', url: 'http://ec2-52-27-51-241.us-west-2.compute.amazonaws.com/')
      unit2.post_with_links

      assert_unit_links_equal @unit_link, Rentlinx.client.get_links_for_unit(@unit)
      assert_unit_links_equal unit2.links.first, Rentlinx.client.get_links_for_unit(unit2)
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
      invalid_link = Rentlinx::UnitLink.new(propertyID: @prop.propertyID, unitID: @unit.unitID, url: 'I am not a URL!')
      err = assert_raises(Rentlinx::InvalidObject) do
        Rentlinx.client.post_links([invalid_link])
      end

      assert_equal err.message, 'Rentlinx::UnitLink is invalid: {:title=>"is missing"}'
    end
  end

  def test_post_links__to_different_properties_raises_error
    prop_link2 = Rentlinx::PropertyLink.new(VALID_PROPERTY_LINK_ATTRS.merge(propertyID: 'another-property-id'))

    use_vcr do
      exception = assert_raises(Rentlinx::IncompatibleGroupOfObjectsForPost) do
        Rentlinx.client.post_links([@prop_link, prop_link2])
      end
      assert_equal 'These objects cannot be grouped together (\'propertyID\' differ).', exception.message
    end
  end

  private

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

  def assert_unit_links_equal(expected, given_arr)
    assert_equal 1, given_arr.size
    given = given_arr.first
    assert_equal given.class, Rentlinx::UnitLink
    assert_equal expected.propertyID, given.propertyID
    assert_equal expected.unitID, given.unitID
    assert_equal expected.title, given.title
    assert_equal expected.url, given.url
  end
end
