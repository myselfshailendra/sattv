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
  BASE_PACKS = { g: 'Gold', s: 'Silver' }.freeze
  CHANNELS = [{ channel: 'Zee', price: 10 },
              { channel: 'Sony', price: 15 },
              { channel: 'Star Plus', price: 20 },
              { channel: 'Discovery', price: 10 },
              { channel: 'Nat Geo', price: 20 }].freeze
  SERVICES = [{ service: 'LearnEnglish Service', price: 200 },
              { service: 'LearnCooking Service', price: 100 }].freeze

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
end
