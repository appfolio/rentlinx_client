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

  config.before_record do |i|
    i.request.headers.delete('Authentication-Token')
  end
end

def use_vcr
  # Builds a cassette with the format:
  #   name_of_file-name_of_test.yml
  cassette_name =  caller[0][%r{/.*\.}].split('/').last[0..-2] +
                   '-' + caller[0][/`.*'/][1..-2]
  VCR.use_cassette(cassette_name) do
    yield
  end
end

module SetupMethods
  def setup
    Rentlinx.configure do |rentlinx|
      rentlinx.username ENV['RENTLINX_USERNAME'] || '<USERNAME>'
      rentlinx.password ENV['RENTLINX_PASSWORD'] || '<PASSWORD>'
      rentlinx.api_url_prefix ENV['RENTLINX_SITE_URL'] || 'http://localhost'
    end
  end
end

VALID_PROPERTY_ATTRS = {
  propertyID: 'test-property-id',
  description: 'This is a test property.',
  address: '55 Castilian',
  city: 'Santa Barbara',
  state: 'CA',
  zip: '93117',
  marketingName: '',
  hideAddress: '',
  latitude: '',
  longitude: '',
  website: '',
  yearBuilt: '',
  numUnits: '',
  phoneNumber: '(805) 555-5554',
  extension: '',
  faxNumber: '',
  emailAddress: 'support@appfolio.com',
  acceptsHcv: '',
  propertyType: '',
  activeURL: '',
  companyID: 'test-id',
  companyName: 'test company'
}
