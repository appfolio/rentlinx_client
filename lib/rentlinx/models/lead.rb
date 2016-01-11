module Rentlinx
  # An object that represets Rentlinx Leads
  class Lead < Base
    ATTRIBUTES = [:leadID, :refunded, :refund_reason]
    REQUIRED_ATTRIBUTES = [:leadID, :refunded, :refund_reason]

    attr_accessor(*ATTRIBUTES)
  end
end
