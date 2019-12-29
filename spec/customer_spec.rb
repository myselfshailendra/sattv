require 'customer'

describe Customer do
  describe '#new' do
    let(:customer) { Customer.new }
    it { expect(customer.name).to be_nil }
    it { expect(customer.phone).to be_nil }
    it { expect(customer.email).to be_nil }
    it { expect(customer.balance).to eq(100) }
    it { expect(customer.channels).to be_empty }
    it { expect(customer.services).to be_empty }
  end
end