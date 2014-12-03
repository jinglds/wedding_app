class DropShopTag < ActiveRecord::Migration
  def change
  	drop_table :shop_tags
  end
end
