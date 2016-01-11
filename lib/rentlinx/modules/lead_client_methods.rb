module Rentlinx
  # Client methods for leads
  module LeadClientMethods
    private

    def post_lead(lead)
      return false unless lead.valid?
      request('PUT', "leads/#{lead.leadID}", lead.to_hash)
    end
  end
end
