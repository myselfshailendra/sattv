class Customer
  attr_accessor :name, :phone, :email, :balance, :channels, :services

  def initialize
    @balance = 100
    @channels = []
    @services = []
  end
end