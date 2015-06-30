module Rentlinx
  class RentlinxError < StandardError
  end

  class UnexpectedAttributes < RentlinxError
  end

  class InvalidTypeParam < RentlinxError
  end

  class NotConfigured < RentlinxError
    def initialize
      super('Rentlinx is not configured.')
    end
  end

  class InvalidObject < RentlinxError
    def initialize(object)
      super("#{object.class} is invalid: #{object.missing_attributes}")
    end
  end

  class HTTPError < RentlinxError
    attr_reader :response

    def initialize(response, msg = nil)
      @response = response
      super(msg.nil? ? 'Received an unexpected response from the server' : msg)
    end
  end

  class BadRequest < HTTPError
    def initialize(response, message = nil)
      super(response, message || 'The request sent to the server was invalid.')
    end
  end

  class NotFound < HTTPError
    def initialize(response)
      super(response, 'The item you requested could not be found on the remote server.')
    end
  end

  class Forbidden < HTTPError
    def initialize(response)
      super(response, 'You are not permitted to access the item you requested.')
    end
  end

  class ServerError < HTTPError
    def initialize(response)
      super(response, 'The remote server has experienced an error.')
    end
  end
end
