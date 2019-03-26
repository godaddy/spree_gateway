# frozen_string_literal: true

module Spree
  class Gateway::AuthorizeNet < Gateway
    preference :login, :string
    preference :password, :string

    def provider_class
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end
end

module SpreeGatewayAuthorizeNetDecorator
  def options
    super.merge(test: self.preferred_test_mode)
  end
end
Spree::Gateway::AuthorizeNet.prepend SpreeGatewayAuthorizeNetDecorator
