class Order < ApplicationRecord
  belongs_to :customer

  enum payment_method: { credit_card: 0, bank_transfer: 1 }
  enum status: {
    waiting_for_deposit: 0,
    payment_confirmed:   1,
    in_production:       2,
    ready_to_ship:       3,
    shipped:             4
  }
end