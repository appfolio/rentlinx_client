require 'httpclient'
require 'json'
require 'uri'
require 'rentlinx/default'

module Rentlinx
  # Client is the primary interface that users of this gem will utilize.
  class Client
    def initialize(username, password, api_url_prefix)
      @url_prefix = (api_url_prefix + '/').freeze  # Extra slashes are fine
      @api_token ||= authenticate(username, password)
    end

    private

    def authenticate(username, password)
      data = { username: username, password: password }
      response = request('POST', 'authentication/login', data)
      response['AccessToken'].freeze
    end

    def request(method, path, data = nil)
      options = { body: data.to_json, header: Rentlinx::Default.headers }
      response = session.request(method, URI.join(@url_prefix, path), options)
      JSON.parse(response.body)
    end

    def session
      @session ||= HTTPClient.new
    end
  end
end
