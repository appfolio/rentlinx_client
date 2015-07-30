module Rentlinx
  class PropertyLink < Base
    ATTRIBUTES = [:propertyID, :title, :url]

    REQUIRED_ATTRIBUTES = [:propertyID, :title, :url]

    attr_accessor(*ATTRIBUTES)

    def to_hash
      { url: url, title: title }
    end
  end
end