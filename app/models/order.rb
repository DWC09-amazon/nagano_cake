class Order < ApplicationRecord
  belongs_to :customer

  enum payment_method: { credit_card: 0, bank_transfer: 1 }
  # 0: 入金待ち, 1: 入金確認, 2: 制作中, 3: 発送準備中, 4: 発送済み
  enum status: {
    waiting_for_deposit: 0,
    payment_confirmed:   1,
    in_production:       2,
    ready_to_ship:       3,
    shipped:             4
  }
end