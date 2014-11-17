class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :email
    add_index :photos, :shop_id
    add_index :tasks, :event_id
    add_index :events, :user_id
    add_index :shops, :user_id
    add_index :tasks, :event_id
  end
end
