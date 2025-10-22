class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  def subtotal
    product.price_with_tax * amount
  end
end
