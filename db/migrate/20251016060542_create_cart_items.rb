class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|

      t.references :customer, null: false, foreign_key: true, type: :integer
      t.references :item, null: false, foreign_key: true, type: :integer

      t.integer :amount, null: false

      t.timestamps null: false
    end
  end
end
