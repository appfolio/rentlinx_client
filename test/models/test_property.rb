require_relative '../helper'

class PropertyTest < MiniTest::Test
  include SetupMethods

  def test_new
    property = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)

    assert property.valid?

    VALID_PROPERTY_ATTRS.each do |k, v|
      assert_equal v, property.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    property_params = { walkscore: '50505' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::Property.new(property_params)
    end
  end

  def test_property_from_id
    use_vcr do
      prop = Rentlinx::Property.from_id('test-property-id')

      assert prop.valid?
      assert_equal 'test-property-id', prop.propertyID
    end
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
    hash = { companyID: 'test-id', propertyID: 'test-property-id',
             description: 'This is a test property.', address: '55 Castilian',
             city: 'Santa Barbara', state: 'CA', zip: '93117',
             marketingName: '', hideAddress: '', latitude: '', longitude: '',
             website: '', yearBuilt: '', numUnits: '',
             phoneNumber: '(805) 555-5554', extension: '', faxNumber: '',
             emailAddress: 'support@appfolio.com', acceptsHcv: '',
             propertyType: '', activeURL: '', companyName: 'test company' }
    assert_equal hash, property.to_hash
  end

  def test_property_post_method_posts_and_updates
    use_vcr do
      prop = Rentlinx::Property.new(VALID_PROPERTY_ATTRS)
      prop.propertyID = 'test_property_post_method_posts_and_updates'
      prop.marketingName = 'Hello this is mad dog'
      prop.post

      prop = Rentlinx::Property.from_id('test_property_post_method_posts_and_updates')

      assert_equal 'Hello this is mad dog', prop.marketingName
      assert_equal 'test_property_post_method_posts_and_updates', prop.propertyID
      assert_equal 'This is a test property.', prop.description

      prop.description = 'This is the new description'
      prop.post

      prop = Rentlinx::Property.from_id('test_property_post_method_posts_and_updates')

      assert_equal 'This is the new description', prop.description
    end
  end
end
