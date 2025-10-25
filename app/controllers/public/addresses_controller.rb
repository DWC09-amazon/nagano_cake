class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @address = Address.new
    @addresses = current_customer.addresses.all
  end

  def create
    @address = current_customer.addresses.new(address_params)

    if @address.save
      redirect_to addresses_path, notice: "新しい配送先を登録しました。"
    else
      @addresses = current_customer.addresses.all
      flash.now[:alert] = "配送先の登録に失敗しました。"
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "配送先情報を更新しました。"
    else
      flash.now[:alert] = "配送先情報の更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "配送先を削除しました。", status: :see_other
  end

  private

  def set_address
    @address = current_customer.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:postal_code, :address, :name)
  end
end
