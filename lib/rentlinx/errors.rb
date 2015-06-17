module Rentlinx
  class RentlinxError < StandardError
  end

  class UnexpectedAttributes < RentlinxError
  end

  class InvalidTypeParam < RentlinxError
  end
end
