require 'minitest/autorun'
require 'rentlinx'
require_relative 'helper'

# Test Rentlinx
class TestRentlinx < MiniTest::Test
  include SetupMethods

  def test_client
    VCR.use_cassette('test_client') do
      Rentlinx.client(@username, @password, @site_url)
    end
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
