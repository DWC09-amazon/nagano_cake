class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @addresses = current_customer.addresses
  end

  def thanks
  end

  def index
    @orders = current_customer.orders.order(created_at: :desc)
  end
  
end