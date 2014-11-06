class AddChangesToTask < ActiveRecord::Migration
  def change
    change_column :tasks, :rank, :integer, default: "0"

    change_column :tasks, :parent_id, :integer, default: "0"

    change_column :tasks, :completed, :boolean, default: "f"
    change_column :tasks, :redo, :boolean, default: "f"


    change_column :tasks, :optional, :boolean, default: "f"
    change_column :tasks, :importance, :integer, default: "1"


  end
end
