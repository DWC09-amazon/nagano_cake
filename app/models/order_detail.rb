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

  def subtotal
    item.tax_included_price * amount
  end

  def self.making_status_i18n(key)
    I18n.t("enums.order_detail.making_status.#{key}")
  end
end
