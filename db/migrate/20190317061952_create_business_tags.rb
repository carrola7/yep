class CreateBusinessTags < ActiveRecord::Migration[5.2]
  def change
    create_table :business_tags do |t|
      t.integer :business_id
      t.integer :tag_id
    end
  end
end
