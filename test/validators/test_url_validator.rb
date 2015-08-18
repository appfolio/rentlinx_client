require_relative '../helper'

class UrlValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::UrlValidator.new('fakevhost.brokendomain')
    refute v.valid?
    assert_equal 'fakevhost.brokendomain is not a valid URL', v.error

    v = Rentlinx::UrlValidator.new('duck')
    refute v.valid?
    assert_equal 'duck is not a valid URL', v.error

    v = Rentlinx::UrlValidator.new('development.localhost:3000/api/leads')
    refute v.valid?
    assert_equal 'development.localhost:3000/api/leads is not a valid URL', v.error
  end

  def test_processed_value
    v = Rentlinx::UrlValidator.new('https://mrgoose.appfolio.com/api/leads')
    assert_equal 'https://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::UrlValidator.new('http://mrgoose.appfolio.com/api/leads')
    assert_equal 'http://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::UrlValidator.new('mrgoose.appfolio.com/api/leads')
    assert_equal 'mrgoose.appfolio.com/api/leads', v.processed_value
  end
end
