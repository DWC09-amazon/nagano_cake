class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order_detail

  def update
    if @order_detail.update(order_detail_params)
      flash[:notice] = "制作ステータスを更新しました。"
    else
      flash[:alert] = "更新に失敗しました。"
    end
    redirect_to admin_order_path(@order_detail.order)
  end

  private

  def set_order_detail
    @order_detail = OrderDetail.find(params[:id])
  end

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
