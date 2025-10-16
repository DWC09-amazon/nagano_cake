class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      ## 会員id、宛名、郵便番号、住所
      t.integer :customer_id, null: false
      t.string  :name,        null: false
      t.string  :potal_code,  null: false
      t.string  :address,     null: false

      t.timestamps null: false
    end

    add_foreign_key :addresses, :customers, colum: :customer_id
    add_index :addresses, :customer_id
  end
end
