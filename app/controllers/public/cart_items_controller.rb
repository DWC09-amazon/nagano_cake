class Public::CartItemsController < ApplicationController
    before_action :authenticate_customer!

    def index
    @cart_items = current_customer.cart_items.all
    @total_price = calculate_total_price(@cart_items)
  end

  def create
    product_id = params[:cart_item][:product_id]
    amount = params[:cart_item][:amount].to_i
    
    cart_item = current_customer.cart_items.find_by(product_id: product_id)

    if cart_item.present? 
      cart_item.amount += amount
      cart_item.save
    else 
      cart_item = current_customer.cart_items.new(cart_item_params)
      cart_item.save
    end
    redirect_to cart_items_path, notice: "商品をカートに追加しました。"
  end
  
  
  def update
    cart_item = current_customer.cart_items.find(params[:id])
    if cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "数量を変更しました。"
    else
      redirect_to cart_items_path, alert: "数量の変更に失敗しました。"
    end
  end

  def destroy
    cart_item = current_customer.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path, notice: "商品を削除しました。", status: :see_other
  end
  
  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, notice: "カートを空にしました。", status: :see_other
  end

  private
  
  def calculate_total_price(cart_items)
    cart_items.sum(&:subtotal) 
  end
  
  def cart_item_params
    params.require(:cart_item).permit(:product_id, :amount)
  end
end
