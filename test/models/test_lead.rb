require_relative '../helper'

class LeadTest < Minitest::Test
  include SetupMethods

  def test_post
    use_vcr do
      lead = Rentlinx::Lead.new(leadID: 8_552_342, refunded: true, refund_reason: 'I do not like their smell')
      response = lead.post
      assert_equal 'premium_refunded_by_user', response['data']['lead_status']
    end
  end
end
