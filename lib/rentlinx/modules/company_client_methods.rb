module Rentlinx
  # Client methods for companies. No public methods.
  module CompanyClientMethods
    private

    def post_company(company)
      return false unless company.valid?
      request('PUT', "companies/#{company.companyID}", company.to_hash)
    end

    def unpost_company(id)
      request('DELETE', "companies/#{id}")
    end
  end
end
