require 'json'

module Rentlinx
  # Basic error class to be inherited from
  #
  # Use this error to rescue all types of Rentlinx errors
  class RentlinxError < StandardError
  end

  # Thrown when instantiating an object with attributes
  # that object does not support them
  class UnexpectedAttributes < RentlinxError
  end

  # Thrown when posting or getting an invalid type
  class InvalidTypeParam < RentlinxError
  end

  # Thrown when the Rentlinx client is initialized without first
  # being configured
  class NotConfigured < RentlinxError
    def initialize
      super('Rentlinx is not configured.')
    end
  end

  # Thrown when an object that does not pass validation tries
  # to post or update
  class InvalidObject < RentlinxError
    def initialize(object)
      super("#{object.class} is invalid: #{object.error_messages}")
    end
  end

  # Thrown when a group of objects is passed to a batch endpoint but
  # cannot be posted because they belong to different properties
  class IncompatibleGroupOfObjectsForPost < RentlinxError
    def initialize(property)
      super("These objects cannot be grouped together ('#{property}' differ).")
    end
  end

  # A general class of errors for handling issues in the communication with
  # Rentlinx. To be inherited from, or thrown when the server returns a code
  # not otherwise handled.
  class HTTPError < RentlinxError
    attr_reader :response

    def initialize(response, msg = nil)
      @response = response
      super(msg.nil? ? 'Received an unexpected response from the server' : msg)
    end
  end

  # Thrown when error code 400 (bad request) is received
  class BadRequest < HTTPError
    def initialize(response)
      default_message = 'The request sent to the server was invalid.'
      begin
        message = JSON.parse(response.body)['details'] || default_message
      rescue JSON::ParserError
        message = default_message
      end
      super(response, message)
    end
  end

  # Thrown when error code 404 (not found) is received
  class NotFound < HTTPError
    def initialize(response)
      super(response, 'The item you requested could not be found on the remote server.')
    end
  end

  # Thrown when error code 409 (conflict) is received
  class Conflict < HTTPError
    def initialize(response)
      super(response, 'There was a conflict on the remote server.')
    end
  end

  # Thrown when error code 403 (forbidden) is received
  class Forbidden < HTTPError
    def initialize(response)
      super(response, 'You are not permitted to access the item you requested.')
    end
  end

  # Thrown when 500 series error codes (internal server errors) are received
  class ServerError < HTTPError
    def initialize(response)
      super(response, 'The remote server has experienced an error.')
    end
  end
end
