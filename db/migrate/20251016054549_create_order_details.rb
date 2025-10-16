class CreateOrderDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item,  null: false, foreign_key: true

      t.integer :price,         null: false
      t.integer :amount,        null: false
      t.integer :making_status, null: false, default: 0
      t.timestamps null: false
    end

    add_index :order_details, :making_status
  end
end
