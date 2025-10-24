class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy

  # 0: クレジットカード, 1:銀行振込
  enum payment_method: { credit_card: 0, bank_transfer: 1 }
  # 0: 入金待ち, 1: 入金確認, 2: 制作中, 3: 発送準備中, 4: 発送済み
  enum status: {
    waiting_for_deposit: 0,
    payment_confirmed:   1,
    in_production:       2,
    ready_to_ship:       3,
    shipped:             4
  }

  after_update :update_making_statuses, if: :saved_change_to_status?

  def grand_total_price
    order_details.sum(&:subtotal) + shipping_cost
  end

  def self.payment_method_i18n(key)
    I18n.t("enums.order.payment_method.#{key}")
  end

  def self.status_i18n(key)
    I18n.t("enums.order.status.#{key}")
  end

  private

  def update_making_statuses
    if status == "payment_confirmed"
      order_details.update_all(making_status: :waiting)
    end
  end
end