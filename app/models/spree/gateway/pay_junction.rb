module Spree
  class Gateway::PayJunction < Gateway
    preference :login, :string
    preference :password, :string

    def provider_class
      ActiveMerchant::Billing::PayJunctionGateway
    end
  end
end

module SpreeGatewayPayJunctionDecorator
  def options
    super.merge(test: self.preferred_test_mode)
  end
end
Spree::Gateway::PayJunction.prepend SpreeGatewayPayJunctionDecorator
