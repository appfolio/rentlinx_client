require 'logging'
require 'rentlinx/client'
require 'rentlinx/errors'
require 'rentlinx/models/base'
require 'rentlinx/models/property'
require 'rentlinx/models/unit'
require 'rentlinx/models/property_photo'
require 'rentlinx/models/unit_photo'
require 'rentlinx/models/property_amenity'
require 'rentlinx/models/unit_amenity'
require 'rentlinx/models/property_link'
require 'rentlinx/models/unit_link'

# This is the main rentlinx module. All Rentlinx objects
# and methods are namespaced under this module.
module Rentlinx
  @username = nil
  @password = nil
  @site_url = nil

  class << self
    # Allows the configuration of Rentlinx in a configure-block
    # style.
    #
    # @example
    #   Rentlinx.configure do |rentlinx|
    #     rentlinx.username ENV['RENTLINX_USERNAME']
    #     rentlinx.password ENV['RENTLINX_PASSWORD']
    #     rentlinx.site_url 'https://rentlinx.com/api/v2'
    #     rentlinx.log_level :error
    #   end
    def configure(&block)
      block.call(self)
    end

    # Sets and retrieves the username used to log in to Rentlinx
    def username(*args)
      if args.empty?
        @username
      else
        @username = args.first
      end
    end

    # Sets and retrieves the password used to log in to Rentlinx
    def password(*args)
      if args.empty?
        @password
      else
        @password = args.first
      end
    end

    # Sets and retrieves the URL where the API is hosted.
    def site_url(*args)
      if args.empty?
        @site_url
      else
        @site_url = args.first
      end
    end

    # Sets and retrieves the log level, currently only :error
    # and :debug are supported
    def log_level(*args)
      if args.empty?
        @log_level
      else
        @log_level = args.first
      end
    end

    # The client object used for communicating with Rentlinx
    def client
      @client ||= Rentlinx::Client.new
    end

    # The logger object
    def logger(*args)
      if args.empty?
        @logger ||= Logging.logger(STDOUT)
        @logger
      else
        @logger = args.first
      end
    end
  end
end
