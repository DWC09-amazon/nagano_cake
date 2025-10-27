class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  # 0: 製作不可, 1: 製作待ち, 2: 製作中, 3: 製作完了
  enum making_status: {
    impossible: 0,
    waiting:    1,
    making:     2,
    done:       3
  }

  after_update :update_order_status, if: :saved_change_to_making_status?

  def subtotal
    item.tax_included_price * amount
  end

  def self.making_status_i18n(key)
    I18n.t("enums.order_detail.making_status.#{key}")
  end

  private

  def update_order_status
    if making_status == "making"
      order.update(status: :in_production)
    elsif order.order_details.all? { |detail| detail.making_status == "done" }
      order.update(status: :ready_to_ship)
    end
  end
end
