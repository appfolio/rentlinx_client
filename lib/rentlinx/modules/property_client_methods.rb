module Rentlinx
  module PropertyClientMethods
    def get_units_for_property_id(id)
      data = request('GET', "properties/#{id}/units")['data']
      data.map do |unit_data|
        Unit.new(symbolize_data(unit_data))
      end
    end

    private

    def post_property(prop)
      return false unless prop.valid?
      request('PUT', "properties/#{prop.propertyID}", prop.to_hash)
    end

    def unpost_property(id)
      request('DELETE', "properties/#{id}")
    end
  end
end
