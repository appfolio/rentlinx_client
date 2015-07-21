if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end
require 'minitest/autorun'
require 'mocha'
require 'mocha/mini_test'
require 'rentlinx'
require 'vcr'
require 'phony'

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
      rentlinx.site_url ENV['RENTLINX_SITE_URL'] || 'http://localhost'
      rentlinx.log_level :error
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
  phoneNumber: '(805) 452-3214',
  extension: '',
  faxNumber: '',
  emailAddress: 'support@appfolio.com',
  acceptsHcv: '',
  propertyType: '',
  activeURL: '',
  companyID: 'test-id',
  companyName: 'test company'
}

VALID_UNIT_ATTRS = {
  propertyID: 'test-property-id',
  unitID: 'test-unit-id',
  isOpenToLease: true,
  name: 'My new unit',
  description: 'Fabulous unit on the ocean side',
  rent: '1600',
  maxRent: '',
  deposit: '3200',
  maxDeposit: '',
  squareFeet: '',
  maxSquareFeet: '',
  bedrooms: '3',
  fullBaths: '2',
  halfBaths: '',
  isMobilityAccessible: '',
  isVisionAccessible: '',
  isHearingAccessible: '',
  rentIsBasedOnIncome: '',
  dateAvailable: '06/15/2015',
  dateLeasedThrough: '',
  numUnits: '',
  numAvailable: ''
}

VALID_PROPERTY_PHOTO_ATTRS = {
  propertyID: 'test-property-id',
  unitID: nil,
  url: 'http://alexstandke.com/img/me.png',
  caption: 'This is a photo of my house',
  # position: 1,
}

VALID_UNIT_PHOTO_ATTRS = {
  propertyID: 'test-property-id',
  unitID: 'test-unit-id',
  url: 'http://alexstandke.com/img/contact-banner.jpg',
  caption: 'This is a photo of my unit',
  # position: 1,
}

VALID_PROPERTY_AMENITY_ATTRS = {
  propertyID: 'test-property-amenity-id',
  name: 'Garbage Disposal',
  details: 'Some details about your garbage'
}

VALID_UNIT_AMENITY_ATTRS = {
  propertyID: 'test-property-amenity-id',
  unitID: 'test-unit-amenity-id',
  name: 'No Dogs Allowed',
  details: 'We do not like dogs'
}
