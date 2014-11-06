class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :due_date
      t.boolean :completed
      t.boolean :redo
      t.datetime :reminder
      t.boolean :optional
      t.integer :importance
      t.string :note
      t.integer :event_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
