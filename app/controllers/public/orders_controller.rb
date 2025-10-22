class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @addresses = current_customer.addresses
  end

  def show
    @order = current_customer.orders.find(params[:id]) 
  end

  def confirm
    order_params_hash = order_params.to_h
    
    if order_params_hash[:payment_method].present?
      order_params_hash[:payment_method] = order_params_hash[:payment_method].to_i
    end
    
    select_address = order_params_hash.delete(:select_address) 
    address_id = order_params_hash.delete(:address_id)         
  
    @order = Order.new(order_params_hash)
    
    if select_address == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name 
    elsif select_address == "1"
      address = current_customer.addresses.find(address_id) 
      @order.postal_code = address.postal_code
      @order.address = address.address
      @order.name = address.name
    elsif select_address == "2"
    else
      flash.now[:alert] = "お届け先を選択してください。"
      @addresses = current_customer.addresses
      render :new
      return
    end
    
    @cart_items = current_customer.cart_items 
    
    @shipping_cost = 800
    @total_item_price = @cart_items.sum { |cart_item| cart_item.subtotal }
    @total_payment = @shipping_cost + @total_item_price
    
    session[:order] = {
      payment_method: @order.payment_method,
      postal_code: @order.postal_code,
      address: @order.address,
      name: @order.name,
      shipping_cost: @shipping_cost,
      total_payment: @total_payment
    }
  end

  def create
    order_data = session[:order] 
    
    unless order_data.present?
      redirect_to public_orders_new_path, alert: "注文情報がありません。再度入力してください。"
      return
    end

    @order = current_customer.orders.new(order_data)
    
    if @order.save
      
      current_customer.cart_items.each do |cart_item|
        @order.order_details.create!({
          item_id: cart_item.item_id,
          price: (cart_item.item.price * 1.1).round, 
          amount: cart_item.amount,
          making_status: 0
        })
      end
      
      current_customer.cart_items.destroy_all
      
      session.delete(:order)

      redirect_to thanks_orders_path
      
    else
      flash[:alert] = "注文情報に不備があります。再度確認してください。"
      redirect_to new_order_path
    end
  end

  def thanks
  end

  def index
    @orders = current_customer.orders.order(created_at: :desc)
  end
  
  private

  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name, :shipping_cost, :total_payment, :select_address, :address_id)
  end

end