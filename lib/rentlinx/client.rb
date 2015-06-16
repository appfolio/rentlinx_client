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

    def post object
      case object
      when Rentlinx::Property
        post_property(object)
      else
        raise ProgrammerError, "Invalid object: #{object.class}"
      end
    end

    def get type, id
      case type
      when :property
        data = request('GET', "properties/#{id}")["data"]
        data = data.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        data.delete(:type)
        Property.new(data)
      when :unit
        #todo
      else
        raise ProgrammerError, "Type not recognized: #{type}"
      end
    end

    private

    def post_property prop
      return false unless prop.valid?
      request('POST', 'properties', prop.to_hash)
    end

    def authenticate(username, password)
      data = { username: username, password: password }
      response = request('POST', 'authentication/login', data)
      response['AccessToken'].freeze
    end

    def request(method, path, data = nil)
      options = { body: data.to_json, header: Rentlinx::Default.headers(token: @api_token) }
      response = session.request(method, URI.join(@url_prefix, path), options)
      JSON.parse(response.body)
    end

    def session
      @session ||= HTTPClient.new
    end
  end
end
