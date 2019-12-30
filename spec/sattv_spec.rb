require 'sattv'

describe SatTV do
  let(:sattv) { SatTV.new }

  describe '#new' do
    let(:customer) { sattv.customer }
    it { expect(sattv).to be_a(SatTV) }
    it { expect(customer).to be_a(Customer) }
    it { expect(customer.name).to be_nil }
    it { expect(customer.phone).to be_nil }
    it { expect(customer.email).to be_nil }
    it { expect(customer.balance).to eq(100) }
    it { expect(customer.channels).to be_empty }
    it { expect(customer.services).to be_empty }
  end

  describe '#view_balance' do
    context 'when customer is new' do
      after { sattv.view_balance }

      it { expect(STDOUT).to receive(:puts).with('Current balance is 100 Rs.') }
    end

    context 'when customer recharged amoount' do
      after do
        sattv.customer.balance = 500
        sattv.view_balance
      end

      it { expect(STDOUT).to receive(:puts).with('Current balance is 500 Rs.') }
    end
  end

  describe '#recharge_amount' do
    it 'shows recharged amount' do
      expect(sattv).to receive(:gets).and_return(500)
      expect(sattv).to receive(:puts).with('Enter the amount to recharge:')
      expect(sattv).to receive(:puts).with('Recharge completed successfully. Current balance is 600')
      sattv.recharge_amount
    end
  end
end
