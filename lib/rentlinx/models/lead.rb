module Rentlinx
  # An object that represets Rentlinx Leads
  class Lead < Base
    ATTRIBUTES = [:leadID, :refunded, :refund_reason].freeze
    REQUIRED_ATTRIBUTES = [:leadID, :refunded, :refund_reason].freeze

    attr_accessor(*ATTRIBUTES)
  end
end
