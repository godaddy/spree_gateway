RSpec.describe Spree::Gateway::StripeGateway do
  let(:secret_key) { 'key' }
  let(:email) { 'customer@example.com' }

  let(:payment) {
    double('Spree::Payment',
      source: Spree::CreditCard.new,
      order: double('Spree::Order',
        email: email,
        bill_address: bill_address
      )
    )
  }

  let(:provider) do
    double('provider').tap do |p|
      allow(p).to receive(:purchase)
      allow(p).to receive(:authorize)
      allow(p).to receive(:capture)
    end
  end

  before do
    subject.set_preference :secret_key, secret_key
    allow(subject).to receive(:options_for_purchase_or_auth).and_return(['money','cc','opts'])
    allow(subject).to receive(:provider).and_return provider
  end

  describe '#create_profile' do
    before do
      allow(payment.source).to receive(:update_attributes!)
    end

    context 'with an order that has a bill address' do
      let(:bill_address) {
        double('Spree::Address',
          address1: '123 Happy Road',
          address2: 'Apt 303',
          city: 'Suzarac',
          zipcode: '95671',
          state: double('Spree::State', name: 'Oregon'),
          country: double('Spree::Country', name: 'United States')
        )
      }

      it 'stores the bill address with the provider' do
        expect(subject.provider).to receive(:store).with(payment.source, {
          email: email,
          login: secret_key,

          address: {
            address1: '123 Happy Road',
            address2: 'Apt 303',
            city: 'Suzarac',
            zip: '95671',
            state: 'Oregon',
            country: 'United States'
          }
        }).and_return double.as_null_object

        subject.create_profile payment
      end
    end

    context 'with an order that does not have a bill address' do
      let(:bill_address) { nil }

      it 'does not store a bill address with the provider' do
        expect(subject.provider).to receive(:store).with(payment.source, {
          email: email,
          login: secret_key,
        }).and_return double.as_null_object

        subject.create_profile payment
      end

      # Regression test for #141
      context "correcting the card type" do
        before do
          # We don't care about this method for these tests
          allow(subject.provider).to receive(:store).and_return(double.as_null_object)
        end

        it "converts 'American Express' to 'american_express'" do
          payment.source.cc_type = 'American Express'
          subject.create_profile(payment)
          expect(payment.source.cc_type).to eq('american_express')
        end

        it "converts 'Diners Club' to 'diners_club'" do
          payment.source.cc_type = 'Diners Club'
          subject.create_profile(payment)
          expect(payment.source.cc_type).to eq('diners_club')
        end

        it "converts 'Visa' to 'visa'" do
          payment.source.cc_type = 'Visa'
          subject.create_profile(payment)
          expect(payment.source.cc_type).to eq('visa')
        end
      end
    end
  end

  context 'purchasing' do
    after do
      subject.purchase(19.99, 'credit card', {})
    end

    it 'send the payment to the provider' do
      expect(provider).to receive(:purchase).with('money','cc','opts')
    end
  end

  context 'authorizing' do
    after do
      subject.authorize(19.99, 'credit card', {})
    end

    it 'send the authorization to the provider' do
      expect(provider).to receive(:authorize).with('money','cc','opts')
    end
  end

  context 'capturing' do

    after do
      subject.capture(1234, 'response_code', {})
    end

    it 'convert the amount to cents' do
      expect(provider).to receive(:capture).with(1234,anything,anything)
    end

    it 'use the response code as the authorization' do
      expect(provider).to receive(:capture).with(anything,'response_code',anything)
    end
  end

  context 'capture with payment class' do
    let(:gateway) do
      gateway = described_class.new(:environment => 'test', :active => true)
      gateway.set_preference :secret_key, secret_key
      allow(gateway).to receive(:options_for_purchase_or_auth).and_return(['money','cc','opts'])
      allow(gateway).to receive(:provider).and_return provider
      allow(gateway).to receive(:source_required).and_return(true)
      gateway
    end

    let(:order) { Spree::Order.create }

    let(:card) do
      Spree::CreditCard.new(:number => "4111111111111111")
    end

    let(:payment) do
      payment = Spree::Payment.new
      payment.source = card
      payment.order = order
      payment.payment_method = gateway
      payment.amount = 98.55
      payment.state = 'pending'
      payment.response_code = '12345'
      payment
    end

    let!(:success_response) do
      double('success_response', :success? => true,
                               :authorization => '123',
                               :avs_result => { 'code' => 'avs-code' },
                               :cvv_result => { 'code' => 'cvv-code', 'message' => "CVV Result"})
    end
    before { allow(card).to receive(:has_payment_profile?).and_return(true) }
    after do
      payment.capture!
    end

    it 'gets correct amount' do
      expect(provider).to receive(:capture).with(9855,'12345',anything).and_return(success_response)
    end
  end
end
