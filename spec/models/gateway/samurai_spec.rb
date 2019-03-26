RSpec.describe Spree::Gateway::Samurai do
  let(:gateway) { Spree::Gateway::Samurai.create!(name: 'Samurai') }

  context '.provider_class' do
    it 'is a Samurai gateway' do
      skip 'uninitialized constant ActiveMerchant::Billing::SamuraiGateway'
      expect(gateway.provider_class).to eq ::ActiveMerchant::Billing::SamuraiGateway
    end
  end

  context '.payment_profiles_supported?' do
    it 'return true' do
      expect(gateway.payment_profiles_supported?).to eq(true)
    end
  end
end
