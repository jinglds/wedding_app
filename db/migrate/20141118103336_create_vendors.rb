class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.integer :task_id
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.string :contact

      t.timestamps
    end
    add_index :vendors, :task_id
  end
end
