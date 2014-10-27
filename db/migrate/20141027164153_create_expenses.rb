class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :event_id
      t.integer :vendor_id
      t.float :amount
      t.string :expense_type
      t.string :receiver
      t.string :title
      t.string :status

      t.timestamps
    end
    
    add_index :expenses, [:event_id, :created_at]
  end
end
