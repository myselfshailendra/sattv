require 'customer'

class SatTV
  attr_accessor :customer

  MENU = { '1': 'View current balance in the account',
           '2': 'Recharge Account',
           '3': 'View available packs, channels and services',
           '4': 'Subscribe to base packs',
           '5': 'Add channels to an existing subscription',
           '6': 'Subscribe to special services',
           '7': 'View current subscription details',
           '8': 'Update email and phone number for notifications',
           '9': 'Exit' }.freeze
  BASE_PACKS = { g: { pack: 'Gold', price: 100 }, s: { pack: 'Silver', price: 50 } }.freeze
  CHANNELS = [{ channel: 'Zee', price: 10 },
              { channel: 'Sony', price: 15 },
              { channel: 'Star Plus', price: 20 },
              { channel: 'Discovery', price: 10 },
              { channel: 'Nat Geo', price: 20 }].freeze
  SERVICES = [{ service: 'LearnEnglish Service', price: 200 },
              { service: 'LearnCooking Service', price: 100 }].freeze
  PACKAGES = ['View available packs, channels and services',
              'Available packs for subscription',
              'Silver pack: Zee, Sony, Star Plus: 50 Rs.',
              'Gold Pack: Zee, Sony, Star Plus, Discovery, NatGeo: 100 Rs.',
              'Available channels for subscription',
              'Zee: 10 Rs.',
              'Sony: 15 Rs.',
              'Star Plus: 20 Rs.',
              'Discovery: 10 Rs.',
              'NatGeo: 20 Rs.',
              'Available services for subscription',
              'LearnEnglish Service: 200 Rs.',
              'LearnCooking Service: 100 Rs.'].freeze

  def initialize
    @customer = Customer.new
  end

  def view_balance
    puts "Current balance is #{customer.balance} Rs."
  end

  def recharge_amount
    puts 'Enter the amount to recharge:'
    amount = gets
    customer.balance += amount.to_i
    puts "Recharge completed successfully. Current balance is #{customer.balance}"
  end

  def view_packages
    puts PACKAGES.join("\n")
  end

  def subscribe_base
    pack, months = fetch_subscription_details
    return if incorrect_base_pack?(pack)
    return if already_subscribed?(BASE_PACKS[pack.downcase.to_sym][:pack])

    after_discount = chargable_amount(pack, months)
    return if not_enough_money?(after_discount)

    update_customer_record(after_discount, pack, months)
    subscription_amount = BASE_PACKS[pack.downcase.to_sym][:price] * months.to_i
    show_subscription_details(pack, subscription_amount, after_discount)
    send_notifications
  end

  private

  def fetch_subscription_details
    puts 'Subscribe to channel packs'
    puts 'Enter the Pack you wish to subscribe: (Silver: ‘S’, Gold: ‘G’):'
    pack = gets
    puts 'Enter the months:'
    months = gets
    [pack, months]
  end

  def incorrect_base_pack?(pack)
    return false if BASE_PACKS.keys.include?(pack.downcase.to_sym)

    puts 'Wrong Input!'
    true
  end

  def already_subscribed?(base_pack)
    return false unless customer.base_pack.eql? base_pack

    puts "Already Subscribed for - #{base_pack}"
    true
  end

  def chargable_amount(pack, months)
    discount = (months.to_i > 2 ? 10 : 0)
    total = BASE_PACKS[pack.downcase.to_sym][:price] * months.to_i
    total - (discount * total / 100)
  end

  def not_enough_money?(payable)
    return false if enough_money?(payable)

    puts 'Insufficient balance. Please recharge!'
    true
  end

  def enough_money?(payable)
    payable < customer.balance
  end

  def update_customer_record(after_discount, pack, months)
    customer.balance -= after_discount
    customer.base_pack = BASE_PACKS[pack.downcase.to_sym][:pack]
    customer.base_duration = months
  end

  def show_subscription_details(pack, subscription_amount, after_discount)
    puts "You have successfully subscribed the following packs - #{customer.base_pack}"
    puts "Monthly price: #{BASE_PACKS[pack.downcase.to_sym][:price]} Rs."
    puts "No of months: #{customer.base_duration}"
    puts "Subscription Amount: #{subscription_amount} Rs."
    puts "Discount applied: #{subscription_amount - after_discount} Rs."
    puts "Final Price after discount: #{after_discount} Rs."
    puts "Account balance: #{customer.balance} Rs."
  end

  def send_notifications
    puts 'Email notification sent successfully'
    puts 'SMS notification sent successfully'
  end
end
