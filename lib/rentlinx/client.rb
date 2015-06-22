require 'httpclient'
require 'json'
require 'uri'
require 'rentlinx/default'

module Rentlinx
  class Client
    def initialize
      @url_prefix = (Rentlinx.api_url_prefix + '/').freeze  # Extra slashes are fine
      @api_token ||= authenticate(Rentlinx.username, Rentlinx.password)
    end

    def post(object)
      case object
      when Rentlinx::Property
        post_property(object)
      when Rentlinx::Unit
        post_unit(object)
      else
        raise TypeError, "Invalid object: #{object.class}"
      end
    end

    def get(type, id)
      case type
      when :property
        Property.new(process_get("properties/#{id}"))
      when :unit
        Unit.new(process_get("units/#{id}"))
      else
        raise InvalidTypeParam, "Type not recognized: #{type}"
      end
    end

    def get_units_for_property_id(id)
      data = request('GET', "properties/#{id}/units")['data']
      data.map do |unit_data|
        Unit.new(symbolize_data(unit_data))
      end
    end

    private

    def process_get(route)
      data = request('GET', route)['data']
      symbolize_data(data)
    end

    def symbolize_data(data)
      data = data.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v
        memo
      end
      data.delete(:type)
      data
    end

    def post_property(prop)
      return false unless prop.valid?
      request('PUT', "properties/#{prop.propertyID}", prop.to_hash)
    end

    def post_unit(unit)
      return false unless unit.valid?
      request('PUT', "units/#{unit.unitID}", unit.to_hash)
    end

    def authenticate(username, password)
      data = { username: username, password: password }
      response = request('POST', 'authentication/login', data)
      response['AccessToken'].freeze
    end

    def request(method, path, data = nil)
      options = { body: data.to_json, header: authenticated_headers }
      response = session.request(method, URI.join(@url_prefix, path), options)
      JSON.parse(response.body)
    end

    def authenticated_headers
      Rentlinx::Default.headers.tap do |headers|
        headers['Authentication-Token'] = @api_token unless @api_token.nil?
      end
    end

    def session
      @session ||= HTTPClient.new
    end
  end
end
