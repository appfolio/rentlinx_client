module Rentlinx
  # A link on a property
  class PropertyLink < Base
    ATTRIBUTES = [:propertyID, :title, :url]

    REQUIRED_ATTRIBUTES = [:propertyID, :title, :url]

    attr_accessor(*ATTRIBUTES)

    # Converts the link to a hash
    #
    # @return a hash with the url and title of the link
    def to_hash
      { url: url, title: title }
    end
  end
end
