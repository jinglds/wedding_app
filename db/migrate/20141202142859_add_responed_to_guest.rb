class AddResponedToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :responded, :boolean, :default => false
  end
end
