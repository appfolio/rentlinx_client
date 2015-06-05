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
