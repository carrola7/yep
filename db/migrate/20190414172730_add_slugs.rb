class AddSlugs < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slug, :string
    add_column :businesses, :slug, :string
    add_column :tags, :slug, :string
    add_column :reviews, :slug, :string
  end
end
