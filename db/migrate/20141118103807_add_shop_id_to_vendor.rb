class AddShopIdToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :shop_id, :integer
    add_column :vendors, :note, :string
    add_index :vendors, :shop_id
  end
end
