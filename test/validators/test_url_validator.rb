require_relative '../helper'

class URLValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::URLValidator.new('fakevhost.brokendomain')
    refute v.valid?
    assert_equal 'fakevhost.brokendomain is not a valid URL', v.error

    v = Rentlinx::URLValidator.new('duck')
    refute v.valid?
    assert_equal 'duck is not a valid URL', v.error

    v = Rentlinx::URLValidator.new('development.localhost:3000/api/leads')
    refute v.valid?
    assert_equal 'development.localhost:3000/api/leads is not a valid URL', v.error
  end

  def test_processed_value
    v = Rentlinx::URLValidator.new('https://mrgoose.appfolio.com/api/leads')
    assert_equal 'https://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::URLValidator.new('http://mrgoose.appfolio.com/api/leads')
    assert_equal 'http://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::URLValidator.new('mrgoose.appfolio.com/api/leads')
    assert_equal 'mrgoose.appfolio.com/api/leads', v.processed_value
  end
end
