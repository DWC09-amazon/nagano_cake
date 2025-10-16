class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      ## 会員id、宛名、郵便番号、住所
      t.references :customer,     null: false, foreign_key: true, type: :integer
      t.string     :name,         null: false
      t.string     :postal_code,  null: false
      t.string     :address,      null: false

      t.timestamps null: false
    end
    
    add_index :addresses, :customer_id
  end
end
