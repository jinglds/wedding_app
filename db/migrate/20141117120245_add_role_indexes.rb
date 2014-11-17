class AddRoleIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :role
  end
end
