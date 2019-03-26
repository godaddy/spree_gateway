RSpec.describe Spree::SkrillTransaction do
  let(:skrill_transaction) { FactoryBot.create(:skrill_transaction) }

  context '.actions' do
    it { expect(subject.actions).to match_array([]) }
  end
end
