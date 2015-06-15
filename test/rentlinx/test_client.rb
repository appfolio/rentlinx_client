require 'minitest/autorun'
require 'rentlinx'
require_relative '../helper'

# Test the Rentlinx Client
class TestRentlinxClient < MiniTest::Test
  include SetupMethods

  def test_health_check
    VCR.use_cassette('test_client') do
      Rentlinx::Client.health_check(@username, @password, @site_url)
    end
  end
end
