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
    Rentlinx.configure do |rentlinx|
      rentlinx.username ENV['RENTLINX_USERNAME'] || '<USERNAME>'
      rentlinx.password ENV['RENTLINX_PASSWORD'] || '<PASSWORD>'
      rentlinx.api_url_prefix ENV['RENTLINX_SITE_URL'] || 'http://localhost'
    end
  end
end
