require 'httpclient'
require 'json'
require 'uri'
require 'rentlinx/default'
require 'rentlinx/modules/company_client_methods'
require 'rentlinx/modules/property_client_methods'
require 'rentlinx/modules/unit_client_methods'
require 'rentlinx/modules/photo_client_methods'
require 'rentlinx/modules/amenity_client_methods'
require 'rentlinx/modules/link_client_methods'
require 'rentlinx/modules/lead_client_methods'
require 'rentlinx/modules/websites_client_methods'

module Rentlinx
  # This class and its included modules encapsulate all
  # communication directly with the Rentlinx API.
  #
  # It should not be interacted with, the objects provide
  # all the functionality necessary to work with Rentlinx.
  class Client
    include Rentlinx::CompanyClientMethods
    include Rentlinx::PropertyClientMethods
    include Rentlinx::UnitClientMethods
    include Rentlinx::PhotoClientMethods
    include Rentlinx::AmenityClientMethods
    include Rentlinx::LinkClientMethods
    include Rentlinx::LeadClientMethods
    include Rentlinx::WebsitesClientMethods

    # Returns a new instance of client. Avoid using.
    #
    # Note that the method {Rentlinx.client} initializes and caches
    # an instance of the Rentlinx client. This method should be used
    # instead of this one when interacting directly with the client
    # to avoid making multiple connections to Rentlinx.
    #
    # Rentlinx must be configured before invoking this method.
    def initialize
      raise Rentlinx::NotConfigured if Rentlinx.username.nil? ||
                                       Rentlinx.password.nil? ||
                                       Rentlinx.site_url.nil?

      @url_prefix = (Rentlinx.site_url + '/').freeze # Extra slashes are fine
      @api_token ||= authenticate(Rentlinx.username, Rentlinx.password)
    end

    # Pushes an object's attributes out to Rentlinx
    #
    # @param object [Rentlinx::Base] the object to be patched
    def patch(object)
      case object
      when Rentlinx::Property
        raise Rentlinx::InvalidObject, object unless object.patch_valid?
        patch_property(object)
      else
        raise TypeError, "Type not permitted: #{object.class}"
      end
    end

    # Pushes an object's attributes out to Rentlinx
    #
    # @param object [Rentlinx::Base] the object to be posted
    def post(object)
      raise Rentlinx::InvalidObject, object if object.respond_to?(:valid?) && !object.valid?

      case object
      when Rentlinx::Company
        post_company(object)
      when Rentlinx::Property
        post_property(object)
      when Rentlinx::Unit
        post_unit(object)
      when Rentlinx::Lead
        post_lead(object)
      else
        raise TypeError, "Type not permitted: #{object.class}"
      end
    end

    # Unposts an object from Rentlinx
    #
    # @param type [Symbol] the type of object to be unposted
    # @param id [String] the rentlinx id of the object to be unposted
    def unpost(type, id)
      case type
      when :company
        unpost_company(id)
      when :property
        unpost_property(id)
      when :unit
        unpost_unit(id)
      else
        raise TypeError, "Invalid type: #{type}"
      end
    end

    # Pulls the attributes for an object from Rentlinx and instantiates it
    #
    # @param type [Symbol] the type of object to be fetched
    # @param id [String] the rentlinx id of the object to be fetched
    def get(type, id)
      case type
      when :company
        Company.new(process_get("companies/#{id}"))
      when :property
        Property.new(process_get("properties/#{id}"))
      when :unit
        Unit.new(process_get("units/#{id}"))
      else
        raise InvalidTypeParam, "Type not recognized: #{type}"
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

    def authenticate(username, password)
      data = { username: username, password: password }
      response = request('POST', 'authentication/login', data)
      response['AccessToken'].freeze
    end

    def request(method, path, data = nil)
      options = { body: data.to_json, header: authenticated_headers }
      log "#{method} Request to Rentlinx: #{path}\n#{options.inspect}"
      response = session.request(method, URI.join(@url_prefix, path), options)
      response_handler(response)
    end

    def response_handler(response)
      log "#{response.status} Response from Rentlinx:\n#{response.inspect}"
      case response.status
      when 200, 201, 202
        JSON.parse(response.body)
      when 204
        nil # don't attempt to JSON parse emptystring
      when 400
        raise Rentlinx::BadRequest, response
      when 403
        raise Rentlinx::Forbidden, response
      when 404
        raise Rentlinx::NotFound, response
      when 409
        raise Rentlinx::Conflict, response
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

    def log(message)
      message = message.gsub(Rentlinx.username, '<filtered_username>').gsub(Rentlinx.password, '<filtered_password>')
      Rentlinx.logger.info message
    end
  end
end
