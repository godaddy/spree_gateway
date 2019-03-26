# frozen_string_literal: true

module Spree
  class Gateway::SagePay < Gateway
    preference :login, :string
    preference :password, :string
    preference :account, :string

    def provider_class
      ActiveMerchant::Billing::SagePayGateway
    end
  end
end
