class RemoveShopTypeFromShops < ActiveRecord::Migration
  def change
    remove_column :shops, :shop_type, :string
  end
end
