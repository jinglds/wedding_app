class AddVendorIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :vendor_id, :integer
    add_index :tasks, :vendor_id
  end
end
