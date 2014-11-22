class AddDetailsToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :group, :string
    add_column :guests, :table_no, :integer
    add_column :guests, :note, :string
    add_index :guests, [:group, :event_id]
  end
end
