class ChangeLovesToBeTextInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :loves, :text
  end
end
