module Rentlinx
  class RentlinxError < StandardError
  end

  class UnexpectedAttributes < RentlinxError
  end

  class InvalidTypeParam < RentlinxError
  end

  class BadRequest < RentlinxError
    def initialize
      super("The request sent to the server was invalid.")
    end
  end

  class NotFound < RentlinxError
    def initialize
      super("The item you requested could not be found on the remote server.")
    end
  end

  class Forbidden < RentlinxError
    def initialize
      super("You are not permitted to access the item you requested.")
    end
  end

  class ServerError < RentlinxError
    def initialize
      super("The remote server has experienced an error.")
    end
  end
end
