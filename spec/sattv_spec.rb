require 'sattv'

describe SatTV do
  describe '#new' do
    let(:sattv) { SatTV.new }
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
end
