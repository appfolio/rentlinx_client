require 'logging'
require 'rentlinx/client'
require 'rentlinx/errors'
require 'rentlinx/models/base'
require 'rentlinx/models/property'
require 'rentlinx/models/unit'

module Rentlinx
  @username = nil
  @password = nil
  @api_url_prefix = nil

  class << self
    def configure(&block)
      block.call(self)
    end

    def username(*args)
      if args.empty?
        @username
      else
        @username = args.first
      end
    end

    def password(*args)
      if args.empty?
        @password
      else
        @password = args.first
      end
    end

    def api_url_prefix(*args)
      if args.empty?
        @api_url_prefix
      else
        @api_url_prefix = args.first
      end
    end

    def log_level(*args)
      if args.empty?
        @log_level
      else
        @log_level = args.first
      end
    end

    def client
      @client ||= Rentlinx::Client.new
    end

    def logger
      lgr = Logging.logger(STDOUT)
      lgr.level = (@log_level || :error)
      lgr
    end
  end
end
