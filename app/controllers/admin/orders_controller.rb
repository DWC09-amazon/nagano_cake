class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update]

  def show
    @order_details = @order.order_details
    @total = @order_details.sum(&:subtotal)
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました。"
    else
      @order_details = @order.order_details
      @total = @order_details.sum(&:subtotal)
      flash.now[:alert] = "更新に失敗しました。"
      render :show
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
