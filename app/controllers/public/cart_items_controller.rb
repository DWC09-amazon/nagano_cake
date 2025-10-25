class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items.all
    @total_price = calculate_total_price(@cart_items)
  end

  def create
    item_id = params[:item_id].to_i
    amount = params[:amount].to_i

    if amount <= 0
      redirect_to item_path(item_id), alert: "数量を正しく選択してください。"
      return
    end

    cart_item = current_customer.cart_items.find_by(item_id: item_id)

    if cart_item.present? 
      cart_item.amount += amount
      if cart_item.save
        redirect_to cart_items_path, notice: "商品をカートに追加しました。"
      else
        redirect_to item_path(item_id), alert: cart_item.errors.full_messages.join(", ")
      end

    else
      cart_item = current_customer.cart_items.new(cart_item_params)
      if cart_item.save
        redirect_to cart_items_path, notice: "商品をカートに追加しました。"
      else
        redirect_to item_path(item_id), alert: cart_item.errors.full_messages.join(", ") 
      end
    end
  end

  def update
    cart_item = current_customer.cart_items.find(params[:id])

    if cart_item.update(update_params)
      redirect_to cart_items_path, notice: "数量を変更しました。"
    else
      redirect_to cart_items_path, alert: cart_item.errors.full_messages.join(", ") 
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
    params.permit(:item_id, :amount)
  end

  def update_params
    params.require(:cart_item).permit(:amount)
  end
end
