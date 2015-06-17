require 'minitest/autorun'
require 'rentlinx'
require_relative '../helper'

class ClientTest < MiniTest::Test
  include SetupMethods

  def test_post
    VCR.use_cassette('test_post') do
      property = Rentlinx::Property.new(::VALID_PROPERTY_ATTRS)

      client = Rentlinx.client(@username, @password, @site_url)

      client.post(property)
    end
  end

  def test_post__invalid_object
    VCR.use_cassette('test_client') do
      client = Rentlinx.client(@username, @password, @site_url)

      assert_raises(Rentlinx::ProgrammerError) { client.post(1234) }
    end
  end

  def test_get
    VCR.use_cassette('test_get') do
      client = Rentlinx.client(@username, @password, @site_url)

      prop = client.get(:property, 'test-property-id')

      assert prop.valid?
      assert_equal 'test-property-id', prop.propertyID
    end
  end

  def test_get__invalid_type
    VCR.use_cassette('test_client') do
      client = Rentlinx.client(@username, @password, @site_url)

      assert_raises(Rentlinx::ProgrammerError) { client.get(:space_ship, 1) }
    end
  end
end
