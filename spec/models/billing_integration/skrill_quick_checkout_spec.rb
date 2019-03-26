RSpec.describe Spree::BillingIntegration::Skrill::QuickCheckout do
  let(:quick_checkout) { FactoryBot.create(:skrill_quick_checkout) }

  context '.provider_class' do
    it 'is a Billing::Skrill class' do
      expect(quick_checkout.provider_class).to eq ::ActiveMerchant::Billing::Skrill
    end
  end
end
