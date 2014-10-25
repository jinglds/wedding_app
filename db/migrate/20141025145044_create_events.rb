class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :event_type
      t.string :name
      t.datetime :date
      t.datetime :time
      t.float :budget
      t.string :bride_name
      t.string :groom_name

      t.timestamps
    end
  end
end
