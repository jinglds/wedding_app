class AddUserIdToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :user_id, :integer
    add_index :guests, :user_id
  end
end
