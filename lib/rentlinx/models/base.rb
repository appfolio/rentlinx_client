module Rentlinx
  class Base
    def post
      Rentlinx.client.post(self)
    end

    def self.get_from_id(type, id)
      Rentlinx.client.get(type.to_sym, id)
    end
  end
end
