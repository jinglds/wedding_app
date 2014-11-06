class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :due_date
      t.integer :rank
      t.integer :parent_id
      t.boolean :completed
      t.boolean :redo
      t.datetime :reminder
      t.boolean :optional
      t.integer :importance
    end
  end
end
