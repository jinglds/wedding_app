class AddRankToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :rank, :integer, default: "0"
  end
end
