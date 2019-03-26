module Spree
  class Gateway::PayflowPro < Gateway
    preference :login, :string
    preference :password, :password

    def provider_class
      ActiveMerchant::Billing::PayflowGateway
    end
  end
end

module SpreeGatewayPayflowProDecorator
  def options
    super.merge(test: self.preferred_test_mode)
  end
end
Spree::Gateway::PayflowPro.prepend SpreeGatewayPayflowProDecorator
