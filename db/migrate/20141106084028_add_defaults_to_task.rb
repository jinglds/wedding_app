class AddDefaultsToTask < ActiveRecord::Migration
  def change
  	change_column :tasks, :completed, :boolean, default: "f"
  	change_column :tasks, :redo, :boolean, default: "f"
  	change_column :tasks, :optional, :boolean, default: "f"
  	change_column :tasks, :importance, :boolean, default: "1"
  end
end
