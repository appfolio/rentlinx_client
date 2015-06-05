require 'minitest/autorun'
require 'rentlinx'

# Test for Rentlinx module
class TestRentlinx < MiniTest::Test
  def setup
    # We use hide the real values using VCR
    @username = ENV['RENTLINX_USER'] || 'dummy'
    @password = ENV['RENTLINX_PASSWORD'] || 'dummy'
    @site_url = ENV['RENTLINX_URL'] || 'http://httpbin.org'
  end

  def test_client
    Rentlinx.client(@username, @password, @site_url)
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
