[![Gem Version](https://badge.fury.io/rb/rentlinx.svg)](https://rubygems.org/gems/rentlinx)
[![Build Status](https://travis-ci.org/appfolio/rentlinx_client.svg?branch=master)](https://travis-ci.org/appfolio/rentlinx_client)
[![Coverage Status](https://coveralls.io/repos/appfolio/rentlinx_client/badge.svg?branch=master)](https://coveralls.io/r/appfolio/rentlinx_client?branch=master)

# rentlinx_client

_rentlinx_client_ is a ruby wrapper for the RentLinx API.


## Installation

To install from the command line, run: 

    gem install rentlinx

To include in a rails app, include this line in your gemfile:

    gem 'rentlinx'

### Usage

Configure like so:

    Rentlinx.configure do |rentlinx|
      rentlinx.username ENV['RENTLINX_USERNAME']
      rentlinx.password ENV['RENTLINX_PASSWORD']
      rentlinx.site_url 'https://rentlinx.com/api/v2'
      rentlinx.log_level :error
    end

For all endpoints, attributes are defined by the API: https://www.rentlinx.com/mongoose/help

Properties:

    prop = Property.new(attributes)
    prop.post # creates

    prop.website = 'http://example.com'
    prop.post # updates

    prop = Property.from_id('property-id') # fetches

Objects can be created for all endpoints supported by the Rentlinx API, including Units, Amenities, Photos, and Links. For more detailed information, see the [full documentation on rubygems](http://www.rubydoc.info/gems/rentlinx).

## Contributing and development

Pull requests are welcome for this gem. New features require writing new
tests. A pull request be considered for merging once:

* New features are tested
* All tests pass on Travis CI
* The code coverage reported by Coveralls does not decrease without reason

### Testing: Code style

Travis CI runs two test suites. The first suite performs a style check with the
tool rubocop. To run rubocop locally first make sure you have the necessary
tools:

    bundle install

Then, run rubocop across the project's files:

    rubocop

Not all rubocop's rules are set in stone, so once you are receiving only
warnings testing rules that may not make sense, please comment on your pull
request indicating you think the rules should be adjusted with your reasoning.

### Documentation

All new classes, modules, and public methods should be documented in the style
of [yard](http://yardoc.org/). Modified classes and methods should have their
documentation updated accordingly. Tests do not need documentation.

### Testing: Unit tests

The second suite is running minitest. The simplest way to invoke our minitest
suite is via:

    rake

The default rake task actually maps to `rake test`. Additionally individual
test files can be executed via:

    ruby -Ilib:test test/FILENAME.rb

## Copyright and license

Source released under the Simplified BSD License.

Copyright (c), 2015, AppFolio, Inc
