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
  end

  class BadRequest < HTTPError
    def initialize
      super('The request sent to the server was invalid.')
    end
  end

  class NotFound < HTTPError
    def initialize
      super('The item you requested could not be found on the remote server.')
    end
  end

  class Forbidden < HTTPError
    def initialize
      super('You are not permitted to access the item you requested.')
    end
  end

  class ServerError < HTTPError
    def initialize
      super('The remote server has experienced an error.')
    end
  end
end
