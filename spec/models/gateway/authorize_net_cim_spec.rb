RSpec.describe Spree::Gateway::AuthorizeNetCim do
  let (:gateway) { described_class.new }

  context '.provider_class' do
    it 'is a AuthorizeNetCim gateway' do
      expect(gateway.provider_class).to eq ::Spree::Gateway::AuthorizeNetCim
    end
  end

  context '.payment_profiles_supported?' do
    it 'return true' do
      expect(subject.payment_profiles_supported?).to eq(true)
    end
  end

  describe 'options' do
    it 'include :test => true when :test_mode is true' do
      gateway.preferred_test_mode = true
      expect(gateway.options[:test]).to eq(true)
    end

    it 'does not include :test when :test_mode is false' do
      gateway.preferred_test_mode = false
      expect(gateway.options[:test]).to be_nil
    end
  end
end
