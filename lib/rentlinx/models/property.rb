module Rentlinx
  # Defines the property object used for returning and sending properties
  class Property
    ATTRIBUTES = [:companyID, :propertyID, :description, :address, :city, :state,
                  :zip, :marketingName, :hideAddress, :latitude, :longitude,
                  :website, :yearBuilt, :numUnits, :phoneNumber, :extension,
                  :faxNumber, :emailAddress, :acceptsHcv, :propertyType,
                  :activeURL, :companyName]

    REQUIRED_ATTRIBUTES = [:propertyID, :address, :city, :state, :zip,
                           :phoneNumber, :emailAddress]

    REQUIRED_FOR_POST = REQUIRED_ATTRIBUTES + [:companyID, :companyName]

    attr_accessor(*ATTRIBUTES)

    def initialize(attrs)
      ATTRIBUTES.each do |at|
        send("#{at}=", attrs[at])
      end
      remaining_attrs = attrs.keys - ATTRIBUTES
      raise ProgrammerError, "Unexpected Attributes: #{remaining_attrs.join(', ')}" if remaining_attrs.size > 0
    end

    def valid?
      REQUIRED_ATTRIBUTES.map do |at|
        !send(at).nil? && send(at) != ''
      end .inject(&:&)
    end

    def valid_for_post?
      REQUIRED_FOR_POST.map do |at|
        !send(at).nil? && send(at) != ''
      end .inject(&:&)
    end

    def to_hash
      {}.tap do |hash|
        ATTRIBUTES.each do |at|
          hash[at] = send(at)
        end
      end
    end
  end
end
