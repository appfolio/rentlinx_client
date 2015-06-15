require 'vcr'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<AUTH_KEY>') { ENV['RENTLINX_AUTH_KEY'] }
  config.filter_sensitive_data('<PASSWORD>') { ENV['RENTLINX_PASSWORD'] }
  config.filter_sensitive_data('<USERNAME>') { ENV['RENTLINX_USERNAME'] }
  config.filter_sensitive_data('http://localhost') { ENV['RENTLINX_SITE_URL'] }
end

# We use hide the real values using VCR
module SetupMethods
  def setup
    @auth_key = ENV['RENTLINX_AUTH_KEY'] || '<AUTH_KEY>'
    @password = ENV['RENTLINX_PASSWORD'] || '<PASSWORD>'
    @username = ENV['RENTLINX_USERNAME'] || '<USERNAME>'
    @site_url = ENV['RENTLINX_SITE_URL'] || 'http://localhost'
  end
end
