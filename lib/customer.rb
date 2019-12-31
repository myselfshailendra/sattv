class Customer
  attr_accessor :name, :phone, :email, :balance, :channels, :services, :base_pack, :base_amount, :base_duration

  def initialize
    @balance = 100
    @channels = []
    @services = []
  end
end