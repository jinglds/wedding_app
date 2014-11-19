class CreateEventVendors < ActiveRecord::Migration
  def change
    create_table :event_vendors do |t|
      t.integer :event_id
      t.integer :vendor_id

      t.timestamps
    end
    add_index :event_vendors, [:event_id, :vendor_id]
  end
end
