require 'rentlinx/version'

module Rentlinx
  # The default headers for the Rentlinx client
  module Default
    USER_AGENT = "Rentlinx Ruby Client #{Rentlinx::VERSION}".freeze

    class << self
      def headers
        { 'Content-Type' => 'application/json',
          'User-Agent' => USER_AGENT }
      end
    end
  end
end
