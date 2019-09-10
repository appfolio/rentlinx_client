if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end
require 'minitest/autorun'
require 'mocha'
require 'mocha/mini_test'
require 'rentlinx'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<PASSWORD>') { ENV['RENTLINX_PASSWORD'] }
  config.filter_sensitive_data('<USERNAME>') { ENV['RENTLINX_USERNAME'] }
  config.filter_sensitive_data('http://localhost') { ENV['RENTLINX_SITE_URL'] }

  config.filter_sensitive_data('{"AccessToken":"<ACCESS_TOKEN>"}') do |i|
    body = i.response.body
    body =~ /{"AccessToken":"([A-Z0-9-]+)"}/ ? body : nil
  end

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

VALID_COMPANY_ATTRS = {
  companyID: 'test-company-id',
  companyCapAmount: BigDecimal.new('1000.00')
}.freeze

VALID_PROPERTY_ATTRS = {
  propertyID: 'test-property-id',
  description: 'This is a test property.',
  address: '55 Castilian',
  city: 'Santa Barbara',
  state: 'CA',
  zip: '93117',
  phoneNumber: '(805) 452-3214',
  emailAddress: 'support@appfolio.com',
  companyID: 'test-company-id',
  companyName: 'test company',
  rentlinxID: 54_321
}.freeze

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
}.freeze

VALID_PROPERTY_PHOTO_ATTRS = {
  propertyID: 'test-property-id',
  unitID: nil,
  url: 'http://alexstandke.com/img/me.png',
  caption: 'This is a photo of my house',
  # position: 1,
}.freeze

VALID_UNIT_PHOTO_ATTRS = {
  propertyID: 'test-property-id',
  unitID: 'test-unit-id',
  url: 'http://alexstandke.com/img/contact-banner.jpg',
  caption: 'This is a photo of my unit',
  # position: 1,
}.freeze

VALID_PROPERTY_AMENITY_ATTRS = {
  propertyID: 'test-property-amenity-id',
  name: 'Garbage Disposal',
  details: 'Some details about your garbage'
}.freeze

VALID_UNIT_AMENITY_ATTRS = {
  propertyID: 'test-property-amenity-id',
  unitID: 'test-unit-amenity-id',
  name: 'No Dogs Allowed',
  details: 'We do not like dogs'
}.freeze

VALID_PROPERTY_LINK_ATTRS = {
  propertyID: 'test-property-link-id',
  url: 'http://google.com/',
  title: 'Ring ding'
}.freeze

VALID_UNIT_LINK_ATTRS = {
  propertyID: 'test-property-link-id',
  unitID: 'sebastiens forest hut',
  url: 'http://youtube.com/',
  title: 'Only You Can Prevent Wildfires!'
}.freeze
