class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :event_id
      t.string :side
      t.string :name
      t.string :prefix
      t.integer :adults
      t.integer :children
      t.string :phone
      t.string :address
      t.string :gender
      t.string :status

      t.timestamps
    end
    add_index :guests, :event_id
    add_index :guests, [:side, :event_id]

  end
end
