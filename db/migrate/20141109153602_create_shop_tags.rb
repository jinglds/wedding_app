class CreateShopTags < ActiveRecord::Migration
  def change
    create_table :shop_tags do |t|
      t.string :name
      t.integer :count

      t.timestamps
    end
  end
end
