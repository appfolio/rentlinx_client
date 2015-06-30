require 'httpclient'
require 'json'
require 'uri'
require 'rentlinx/default'

module Rentlinx
  class Client
    def initialize
      raise Rentlinx::NotConfigured if Rentlinx.username.nil? ||
                                       Rentlinx.password.nil? ||
                                       Rentlinx.api_url_prefix.nil?

      @url_prefix = (Rentlinx.api_url_prefix + '/').freeze  # Extra slashes are fine
      @api_token ||= authenticate(Rentlinx.username, Rentlinx.password)
    end

    def post(object)
      case object
      when Rentlinx::Property
        raise Rentlinx::InvalidObject, object unless object.valid?
        post_property(object)
      when Rentlinx::Unit
        raise Rentlinx::InvalidObject, object unless object.valid?
        post_unit(object)
      else
        raise TypeError, "Type not permitted: #{object.class}"
      end
    end

    def unpost(type, id)
      case type
      when :property
        unpost_property(id)
      when :unit
        unpost_unit(id)
      else
        raise TypeError, "Invalid type: #{type}"
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

    def unpost_property(id)
      request('DELETE', "properties/#{id}")
    end

    def unpost_unit(id)
      request('DELETE', "units/#{id}")
    end

    def authenticate(username, password)
      data = { username: username, password: password }
      response = request('POST', 'authentication/login', data)
      response['AccessToken'].freeze
    end

    def request(method, path, data = nil)
      options = { body: data.to_json, header: authenticated_headers }
      Rentlinx.logger.debug "#{method} Request to #{path}\n#{options.inspect}"
      response = session.request(method, URI.join(@url_prefix, path), options)
      response_handler(response)
    end

    def response_handler(response)
      case response.status
      when 200, 201, 202
        JSON.parse(response.body)
      when 204
        nil # don't attempt to JSON parse emptystring
      when 400
        body = JSON.parse(response.body)
        raise Rentlinx::BadRequest, response, body['details']
      when 403
        raise Rentlinx::Forbidden, response
      when 404
        raise Rentlinx::NotFound, response
      when 500, 501, 502, 503, 504, 505
        raise Rentlinx::ServerError, response
      else
        raise Rentlinx::HTTPError, response
      end
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
