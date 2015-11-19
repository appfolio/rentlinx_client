module Rentlinx
  # Client methods for property
  module PropertyClientMethods
    # Gets all the units for a given property id
    #
    # @param id [String] the id of the property
    # @return a list of Rentlinx::Unit objects
    def get_units_for_property_id(id)
      data = request('GET', "properties/#{id}/units")['data']
      data.map do |unit_data|
        Unit.new(symbolize_data(unit_data))
      end
    end

    private

    def patch_property(prop)
      return false unless prop.patch_valid?
      # TODO: change to 'PATCH' once Rentlinx supports it
      request('PUT', "properties/#{prop.propertyID}", prop.to_hash)
    end

    def post_property(prop)
      return false unless prop.valid?
      request('PUT', "properties/#{prop.propertyID}", prop.to_hash)
    end

    def unpost_property(id)
      request('DELETE', "properties/#{id}")
    end
  end
end
