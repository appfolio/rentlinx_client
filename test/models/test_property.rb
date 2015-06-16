require 'minitest/autorun'
require 'rentlinx'
require_relative '../helper'

# Test the property object
class PropertyTest < MiniTest::Test
  def test_new
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)

    assert property.valid?

    VALID_PROPERTY_ATTRS.each do |k,v|
      assert_equal v, property.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    property_params = { walkscore: '50505' }
    assert_raises(Rentlinx::ProgrammerError) { Rentlinx::Property.new(property_params) }
  end

  def test_valid__missing_required_params
    property_params = {}
    property = Rentlinx::Property.new(property_params)
    assert !property.valid?
  end

  def test_valid_for_post
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)

    assert property.valid?
    assert property.valid_for_post?

    property.companyID = nil

    assert property.valid?
    assert !property.valid_for_post?

    property.companyID = 'test-company-id'
    property.companyName = nil

    assert property.valid?
    assert !property.valid_for_post?
  end

  def test_to_hash
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
    hash = {:companyID=>"test-id", :propertyID=>"test-property-id", :description=>"This is a test property.", :address=>"55 Castilian", :city=>"Santa Barbara", :state=>"CA", :zip=>"93117", :marketingName=>"", :hideAddress=>"", :latitude=>"", :longitude=>"", :website=>"", :yearBuilt=>"", :numUnits=>"", :phoneNumber=>"(805) 555-5554", :extension=>"", :faxNumber=>"", :emailAddress=>"support@appfolio.com", :acceptsHcv=>"", :propertyType=>"", :activeURL=>"", :companyName=>"test company"}
    assert_equal hash, property.to_hash
  end
end
