module Rentlinx
  class PropertyPhoto < Base
    ATTRIBUTES = [:url, :caption, :position, :propertyID, :unitID]

    REQUIRED_ATTRIBUTES = [:url, :propertyID]

    attr_accessor(*ATTRIBUTES)

    def to_hash
      { url: url, caption: caption }
    end
  end
end
