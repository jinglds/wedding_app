class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.integer :shop_id
      t.integer :user_id
      t.integer :parent_id
      t.text :content

      t.timestamps
    end
  end
end
