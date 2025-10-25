class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10 }

  def subtotal
    item.tax_included_price * amount
  end
end