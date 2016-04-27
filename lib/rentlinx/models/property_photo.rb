module Rentlinx
  # A photo on a property
  class PropertyPhoto < Base
    ATTRIBUTES = [:url, :caption, :position, :propertyID, :unitID].freeze

    REQUIRED_ATTRIBUTES = [:url, :propertyID].freeze

    attr_accessor(*ATTRIBUTES)

    # Converts the photo to a hash
    #
    # @return a hash with the url and caption of the photo
    def to_hash
      { url: url, caption: caption }
    end
  end
end
