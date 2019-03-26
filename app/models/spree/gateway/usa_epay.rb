# frozen_string_literal: true

module Spree
  class Gateway::UsaEpay < Gateway
    preference :login, :string

    def provider_class
      ActiveMerchant::Billing::UsaEpayGateway
    end
  end
end
