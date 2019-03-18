class CreateBusinesses < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :country
      t.string :phone
      t.integer :user_id
      t.integer :price
      t.timestamps
    end
  end
end
