require 'sattv'

RSpec.describe SatTV, type: :model do
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

  describe '#view_packages' do
    after { sattv.view_packages }

    it { expect(STDOUT).to receive(:puts).with(SatTV::PACKAGES.join("\n")) }
  end

  describe '#subscribe_base' do
    context 'when correct input but subscribe for 3 or more months' do
      before { sattv.customer.balance = 600 }

      it 'recharge gold base pack with discount' do
        expect(sattv).to receive(:gets).and_return('G')
        expect(sattv).to receive(:gets).and_return('3')
        expect(sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv).to receive(:puts).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv).to receive(:puts).with('Enter the months:')
        expect(sattv).to receive(:puts).with('You have successfully subscribed the following packs - Gold')
        expect(sattv).to receive(:puts).with('Monthly price: 100 Rs.')
        expect(sattv).to receive(:puts).with('No of months: 3')
        expect(sattv).to receive(:puts).with('Subscription Amount: 300 Rs.')
        expect(sattv).to receive(:puts).with('Discount applied: 30 Rs.')
        expect(sattv).to receive(:puts).with('Final Price after discount: 270 Rs.')
        expect(sattv).to receive(:puts).with('Account balance: 330 Rs.')
        expect(sattv).to receive(:puts).with('Email notification sent successfully')
        expect(sattv).to receive(:puts).with('SMS notification sent successfully')
        sattv.subscribe_base
      end
    end

    context 'when correct input but subscribe for less than 3 months' do
      before { sattv.customer.balance = 600 }

      it 'recharge gold base pack without discount' do
        expect(sattv).to receive(:gets).and_return('G')
        expect(sattv).to receive(:gets).and_return('2')
        expect(sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv).to receive(:puts).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv).to receive(:puts).with('Enter the months:')
        expect(sattv).to receive(:puts).with('You have successfully subscribed the following packs - Gold')
        expect(sattv).to receive(:puts).with('Monthly price: 100 Rs.')
        expect(sattv).to receive(:puts).with('No of months: 2')
        expect(sattv).to receive(:puts).with('Subscription Amount: 200 Rs.')
        expect(sattv).to receive(:puts).with('Discount applied: 0 Rs.')
        expect(sattv).to receive(:puts).with('Final Price after discount: 200 Rs.')
        expect(sattv).to receive(:puts).with('Account balance: 400 Rs.')
        expect(sattv).to receive(:puts).with('Email notification sent successfully')
        expect(sattv).to receive(:puts).with('SMS notification sent successfully')
        sattv.subscribe_base
      end
    end

    context 'when correct input but already subscribed' do
      before do
        sattv.customer.base_pack = 'Gold'
      end

      it 'shows message to already subscribed' do
        expect(sattv).to receive(:gets).and_return('G')
        expect(sattv).to receive(:gets).and_return('3')
        expect(sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv).to receive(:puts).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv).to receive(:puts).with('Enter the months:')
        expect(sattv).to receive(:puts).with('Already Subscribed for - Gold')
        sattv.subscribe_base
      end
    end

    context 'when correct input but low balance' do
      before { sattv.customer.balance = 200 }

      it 'shows message to insufficient balance' do
        expect(sattv).to receive(:gets).and_return('G')
        expect(sattv).to receive(:gets).and_return('3')
        expect(sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv).to receive(:puts).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv).to receive(:puts).with('Enter the months:')
        expect(sattv).to receive(:puts).with('Insufficient balance. Please recharge!')
        sattv.subscribe_base
      end
    end

    context 'when incorrect input' do
      it 'shows message to wrong input' do
        expect(sattv).to receive(:gets).and_return('B')
        expect(sattv).to receive(:gets).and_return('3')
        expect(sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv).to receive(:puts).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv).to receive(:puts).with('Enter the months:')
        expect(sattv).to receive(:puts).with('Wrong Input!')
        sattv.subscribe_base
      end
    end
  end

  describe '#subscribe_channel' do
    context 'when correct input' do
      it 'add channels Discovery and Nat Geo' do
        expect(sattv).to receive(:gets).and_return('Discovery, Nat Geo')
        expect(sattv).to receive(:puts).with('Add channels to existing subscription')
        expect(sattv).to receive(:puts).with('Enter channel names to add (separated by commas):')
        expect(sattv).to receive(:puts).with('Channels added successfully.')
        expect(sattv).to receive(:puts).with('Account balance: 70 Rs.')
        sattv.subscribe_channel
      end
    end

    context 'when correct input but with already existing channel' do
      before { sattv.customer.channels << ['Discovery'] }
      it 'shows message to already subscribed' do
        expect(sattv).to receive(:gets).and_return('Discovery, Nat Geo')
        expect(sattv).to receive(:puts).with('Add channels to existing subscription')
        expect(sattv).to receive(:puts).with('Enter channel names to add (separated by commas):')
        expect(sattv).to receive(:puts).with('Already Subscribed for - Discovery')
        sattv.subscribe_channel
      end
    end

    context 'when correct input but with low balance' do
      before { sattv.customer.balance = 10 }
      it 'shows message to insufficient balance' do
        expect(sattv).to receive(:gets).and_return('Discovery, Nat Geo')
        expect(sattv).to receive(:puts).with('Add channels to existing subscription')
        expect(sattv).to receive(:puts).with('Enter channel names to add (separated by commas):')
        expect(sattv).to receive(:puts).with('Insufficient balance. Please recharge!')
        sattv.subscribe_channel
      end
    end

    context 'when correct input but with wrong channel' do
      it 'shows message wrong channel name' do
        expect(sattv).to receive(:gets).and_return('Discovere, Nat Geo')
        expect(sattv).to receive(:puts).with('Add channels to existing subscription')
        expect(sattv).to receive(:puts).with('Enter channel names to add (separated by commas):')
        expect(sattv).to receive(:puts).with('Wrong channel name!')
        sattv.subscribe_channel
      end
    end
  end
end
