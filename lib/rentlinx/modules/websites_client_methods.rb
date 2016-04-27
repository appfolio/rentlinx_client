module Rentlinx
  # Client method for websites method on properties
  module WebsitesClientMethods
    def get_websites(id)
      request('get', "properties/#{id}/websites")['data']
    end
  end
end
