class Public::CustomersController < ApplicationController
    
  before_action :authenticate_customer! 

  
  def show
    @customer = current_customer
  end
  
 def edit
    @customer = current_customer
  end
  
  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to my_page_path, notice: "登録情報を更新しました。"
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(
      :sei, :mei, :kana_sei, :kana_mei, :postal_code, :address, :telephone_number, :email
    )
  end
end
