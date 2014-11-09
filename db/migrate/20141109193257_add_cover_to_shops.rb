class AddCoverToShops < ActiveRecord::Migration
  def change
    add_column :shops, :cover_url, :string, default: "default.png"
  end
end
