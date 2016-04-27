module Rentlinx
  # An object that represents a Rentlinx company.
  class Company < Base
    ATTRIBUTES = [:companyID, :companyCapAmount].freeze

    REQUIRED_ATTRIBUTES = [:companyID].freeze

    attr_accessor(*ATTRIBUTES)

    # Queries Rentlinx and builds a company with the given ID
    #
    # The returned company will have all the attributes Rentlinx
    # has for the company on their end.
    #
    # @param id [String] the Rentlinx id of the company
    # @return a Rentlinx::Company that is up to date with the remote one
    def self.from_id(id)
      get_from_id(:company, id)
    end
  end
end
