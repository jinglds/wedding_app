class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.integer :event_id
      t.boolean :completed, default: false
      t.string :title
      t.integer :time_range
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
