class AddEventIdToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :event_id, :integer
    add_index :vendors, :event_id
  end
end
