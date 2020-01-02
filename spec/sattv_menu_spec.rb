require 'sattv_menu'

RSpec.describe SatTVMenu, type: :model do
  let(:sattv_menu) { SatTVMenu.new }

  describe '#new' do
    it { expect(sattv_menu).to be_a(SatTVMenu) }
    it { expect(sattv_menu.sattv).to be_a(SatTV) }
    it { expect(sattv_menu.sattv.customer).to be_a(Customer) }
  end

  describe '#menu' do
    context 'when input is 1' do
      it 'shows the customer balance' do
        expect(sattv_menu.sattv).to receive(:puts).with('Current balance is 100 Rs.')
        sattv_menu.menu(1)
      end
    end

    context 'when input is 2' do
      it 'shows recharged amount' do
        expect(sattv_menu.sattv).to receive(:gets).and_return(500)
        expect(sattv_menu.sattv).to receive(:print).with('Enter the amount to recharge:')
        expect(sattv_menu.sattv).to receive(:puts).with('Recharge completed successfully. Current balance is 600')
        sattv_menu.menu(2)
        expect(sattv_menu.sattv.customer.balance).to eq(600)
      end
    end

    context 'when input is 3' do
      it 'shows all packages' do
        expect(sattv_menu.sattv).to receive(:puts).with(SatTV::PACKAGES.join("\n"))
        sattv_menu.menu(3)
      end
    end

    context 'when input is 4' do
      before { sattv_menu.sattv.customer.balance = 600 }

      it 'recharge gold base pack with discount' do
        expect(sattv_menu.sattv).to receive(:gets).and_return('G')
        expect(sattv_menu.sattv).to receive(:gets).and_return('3')
        expect(sattv_menu.sattv).to receive(:puts).with('Subscribe to channel packs')
        expect(sattv_menu.sattv).to receive(:print).with('Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):')
        expect(sattv_menu.sattv).to receive(:print).with('Enter the months:')
        expect(sattv_menu.sattv).to receive(:puts).with('You have successfully subscribed the following packs - Gold')
        expect(sattv_menu.sattv).to receive(:puts).with('Monthly price: 100 Rs.')
        expect(sattv_menu.sattv).to receive(:puts).with('No of months: 3')
        expect(sattv_menu.sattv).to receive(:puts).with('Subscription Amount: 300 Rs.')
        expect(sattv_menu.sattv).to receive(:puts).with('Discount applied: 30 Rs.')
        expect(sattv_menu.sattv).to receive(:puts).with('Final Price after discount: 270 Rs.')
        expect(sattv_menu.sattv).to receive(:puts).with('Account balance: 330 Rs.')
        sattv_menu.menu(4)
        expect(sattv_menu.sattv.customer.balance).to eq(330)
        expect(sattv_menu.sattv.customer.base_pack).to eq('Gold')
        expect(sattv_menu.sattv.customer.base_duration).to eq('3')
      end
    end

    context 'when input is 5' do
      it 'add channels Discovery and Nat Geo' do
        expect(sattv_menu.sattv).to receive(:gets).and_return('Discovery, Nat Geo')
        expect(sattv_menu.sattv).to receive(:puts).with('Add channels to existing subscription')
        expect(sattv_menu.sattv).to receive(:print).with('Enter channel names to add (separated by commas):')
        expect(sattv_menu.sattv).to receive(:puts).with('Channels added successfully.')
        expect(sattv_menu.sattv).to receive(:puts).with('Account balance: 70 Rs.')
        sattv_menu.menu(5)
        expect(sattv_menu.sattv.customer.balance).to eq(70)
        expect(sattv_menu.sattv.customer.channels).to eq(['Discovery', 'Nat Geo'])
      end
    end

    context 'when input is 6' do
      before { sattv_menu.sattv.customer.balance = 400 }

      it 'add service LearnEnglish' do
        expect(sattv_menu.sattv).to receive(:gets).and_return('LearnEnglish')
        expect(sattv_menu.sattv).to receive(:puts).with('Subscribe to special services')
        expect(sattv_menu.sattv).to receive(:print).with('Enter the service name:')
        expect(sattv_menu.sattv).to receive(:puts).with('Service subscribed successfully')
        expect(sattv_menu.sattv).to receive(:puts).with('Account balance: 200 Rs.')
        sattv_menu.menu(6)
        expect(sattv_menu.sattv.customer.balance).to eq(200)
        expect(sattv_menu.sattv.customer.services).to eq(['LearnEnglish'])
      end
    end

    context 'when input is 7' do
      it 'add service LearnEnglish' do
        expect(sattv_menu.sattv).to receive(:puts).with('View current subscription details')
        expect(sattv_menu.sattv).to receive(:puts).with('Currently subscribed packs and channels: ')
        expect(sattv_menu.sattv).to receive(:puts).with('Currently subscribed services: ')
        sattv_menu.menu(7)
      end
    end

    context 'when input is 8' do
      it 'add service LearnEnglish' do
        expect(sattv_menu.sattv).to receive(:gets).and_return('john@mailinator.com')
        expect(sattv_menu.sattv).to receive(:gets).and_return('7042252398')
        expect(sattv_menu.sattv).to receive(:puts).with('Update email and phone number for notifications')
        expect(sattv_menu.sattv).to receive(:print).with('Enter the email: ')
        expect(sattv_menu.sattv).to receive(:print).with('Enter phone: ')
        expect(sattv_menu.sattv).to receive(:puts).with('Email and Phone updated successfully')
        sattv_menu.menu(8)
        expect(sattv_menu.sattv.customer.email).to eq('john@mailinator.com')
        expect(sattv_menu.sattv.customer.phone).to eq('7042252398')
      end
    end

    context 'when input is 9' do
      it 'stop the program' do
        sattv_menu.menu(9)
      end
    end
  end

  describe '#start_menu' do
    it 'shows the SatTV Menu' do
      show_menu(sattv_menu)
      expect(sattv_menu).to receive(:puts).with('===================================================================')
      expect(sattv_menu).to receive(:puts).with('Enter the option: ')
      sattv_menu.start_menu
    end
  end

  def show_menu(sattv_menu)
    expect(sattv_menu).to receive(:puts).with('Welcome to SatTV')
    expect(sattv_menu).to receive(:puts).with('  1. View current balance in the account')
    expect(sattv_menu).to receive(:puts).with('  2. Recharge Account')
    expect(sattv_menu).to receive(:puts).with('  3. View available packs, channels and services')
    expect(sattv_menu).to receive(:puts).with('  4. Subscribe to base packs')
    expect(sattv_menu).to receive(:puts).with('  5. Add channels to an existing subscription')
    expect(sattv_menu).to receive(:puts).with('  6. Subscribe to special services')
    expect(sattv_menu).to receive(:puts).with('  7. View current subscription details')
    expect(sattv_menu).to receive(:puts).with('  8. Update email and phone number for notifications')
    expect(sattv_menu).to receive(:puts).with('  9. Exit')
  end
end
