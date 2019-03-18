class UpdateBirthdayOnUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :birthday
    add_column :users, :birthday_d, :integer
    add_column :users, :birthday_m, :string
    add_column :users, :birthday_y, :integer
  end
end
