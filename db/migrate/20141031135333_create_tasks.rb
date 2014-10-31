class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :event_id
      t.string :title
      t.datetime :deadline
      t.boolean :status
      t.string :note
      t.datetime :reminder
      t.integer :user_id

      t.timestamps
    end
  end
end
