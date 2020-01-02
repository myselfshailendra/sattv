require_relative 'sattv.rb'
require_relative 'customer'

class SatTVMenu
  attr_accessor :sattv

  def initialize
    @sattv = SatTV.new
  end

  def start_menu
    show_menu
    loop do
      puts '==================================================================='
      print 'Enter the option: '
      option = gets
      exit if option.eql?(9)
      menu(option)
    end
  end

  def menu(option)
    case option.to_i
    when 1
      sattv.view_balance
    when 2
      sattv.recharge_amount
    when 3
      sattv.view_packages
    when 4
      sattv.subscribe_base
    when 5
      sattv.subscribe_channel
    when 6
      sattv.subscribe_service
    when 7
      sattv.view_subscription
    when 8
      sattv.update_profile
    when 9
      exit
    else
      puts 'Wrong Option!'
    end
  end

  private

  def show_menu
    puts 'Welcome to SatTV'
    SatTV::MENU.each { |menu| puts "  #{menu.join('. ')}" }
  end
end
