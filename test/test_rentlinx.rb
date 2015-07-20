require_relative 'helper'

class TestRentlinx < MiniTest::Test
  include SetupMethods

  def test_client
    use_vcr do
      Rentlinx.client
    end
  end

  def test_credentials
    Rentlinx.username('Test')
    assert_equal 'Test', Rentlinx.username

    Rentlinx.password('Test')
    assert_equal 'Test', Rentlinx.password

    Rentlinx.site_url('Test')
    assert_equal 'Test', Rentlinx.site_url
  end

  def test_version
    version_regex = /^\d+\.\d+(\.\d+)?((a|b|rc)\d+)?$/
    # Test the regex
    assert_match(version_regex, '1.0')
    assert_match(version_regex, '1.0b1')
    assert_match(version_regex, '10.10.10')
    assert_match(version_regex, '10.10.10rc10')
    # Test the version string
    assert_match(version_regex, Rentlinx::VERSION)
  end
end
