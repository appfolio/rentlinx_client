require 'rentlinx/version'

module Rentlinx
  module Default
    USER_AGENT = "Rentlinx Ruby Client #{Rentlinx::VERSION}".freeze

    class << self
      def headers(token: nil)
        { 'Content-Type' => 'application/json',
          'User-Agent' => USER_AGENT }.tap do |headers|
            headers['Authentication-Token'] = token unless token.nil?
          end
      end
    end
  end
end
