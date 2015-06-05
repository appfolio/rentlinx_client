require 'minitest/autorun'
require 'rentlinx'
require 'vcr'

# Test for Rentlinx module
class TestRentlinx < MiniTest::Test
  def setup
    # We use hide the real values using VCR
    @auth_key = ENV['RENTLINX_AUTH_KEY'] || '<AUTH_KEY>'
    @password = ENV['RENTLINX_PASSWORD'] || '<PASSWORD>'
    @username = ENV['RENTLINX_USERNAME'] || '<USERNAME>'
    @site_url = ENV['RENTLINX_SITE_URL'] || 'http://localhost'
  end

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
