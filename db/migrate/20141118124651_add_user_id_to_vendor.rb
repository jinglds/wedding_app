class AddUserIdToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :user_id, :integer
    add_index :vendors, :user_id
  end
end
