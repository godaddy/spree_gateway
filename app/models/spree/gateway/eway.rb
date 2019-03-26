# frozen_string_literal: true

module Spree
  class Gateway::Eway < Gateway
    preference :login, :string

    # Note: EWay supports purchase method only (no authorize method).
    def auto_capture?
      true
    end

    def provider_class
      ActiveMerchant::Billing::EwayGateway
    end
  end
end

module SpreeGatewayEwayDecorator
  def options
    super.merge(test: self.preferred_test_mode)
  end
end
Spree::Gateway::Eway.prepend SpreeGatewayEwayDecorator
