class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @orders = Order.includes(:customer).order(created_at: :desc).page(params[:page]).per(10)
  end
end
