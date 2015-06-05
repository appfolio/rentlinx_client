require 'rentlinx/client'

# The Rentlinx module provides the means to interact with the Rentlinx API.
module Rentlinx
  class << self
    def client(*args)
      @client ||= Rentlinx::Client.new(*args)
    end
  end
end
