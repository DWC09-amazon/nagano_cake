class Address < ApplicationRecord
  belongs_to :customer

  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/, message: "はハイフンを含めず、7桁で入力してください" }
  validates :address, presence: true
  validates :name, presence: true

  def address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end
end