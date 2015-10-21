require_relative '../helper'

class CompanyTest < MiniTest::Test
  include SetupMethods

  def test_new
    company = Rentlinx::Company.new(VALID_COMPANY_ATTRS)

    assert company.valid?

    VALID_COMPANY_ATTRS.each do |k, v|
      assert_equal v, company.send(k)
    end
  end

  def test_new__unexpected_attribute_throws_error
    property_params = { walkscore: '50505' }
    assert_raises(Rentlinx::UnexpectedAttributes) do
      Rentlinx::Company.new(property_params)
    end
  end

  def test_company_from_id
    use_vcr do
      prop = Rentlinx::Company.from_id('test-company-id')

      assert prop.valid?
      assert_equal 'test-company-id', prop.companyID
    end
  end

  def test_valid__missing_required_params
    company_params = {}
    company = Rentlinx::Company.new(company_params)
    assert !company.valid?
  end

end
