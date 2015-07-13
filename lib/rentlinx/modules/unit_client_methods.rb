module Rentlinx
  module UnitClientMethods
    private

    def post_unit(unit)
      return false unless unit.valid?
      request('PUT', "units/#{unit.unitID}", unit.to_hash)
    end

    def unpost_unit(id)
      request('DELETE', "units/#{id}")
    end
  end
end
