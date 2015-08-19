require_relative '../helper'

class UrlValidatorTest < MiniTest::Test
  def test_validate
    v = Rentlinx::UrlValidator.new('wrong')
    refute v.valid?
    assert_equal 'wrong is not a valid URL', v.error

    v = Rentlinx::UrlValidator.new('http://$#*&^$@*&.com/')
    refute v.valid?
    assert_equal 'http://$#*&^$@*&.com/ is not a valid URL', v.error

    v = Rentlinx::UrlValidator.new('donaldgoose.4lyfe?')
    refute v.valid?
    assert_equal 'donaldgoose.4lyfe? is not a valid URL', v.error
  end

  def test_processed_value
    v = Rentlinx::UrlValidator.new('https://mrgoose.appfolio.com/api/leads')
    assert_equal 'https://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::UrlValidator.new('http://mrgoose.appfolio.com/api/leads')
    assert_equal 'http://mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::UrlValidator.new('mrgoose.appfolio.com/api/leads')
    assert_equal 'mrgoose.appfolio.com/api/leads', v.processed_value

    v = Rentlinx::UrlValidator.new('https://www.randomcompany.co.jp/shiken_kanryou')
    assert_equal 'https://www.randomcompany.co.jp/shiken_kanryou', v.processed_value
  end
end
