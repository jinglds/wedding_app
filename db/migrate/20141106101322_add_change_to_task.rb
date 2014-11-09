class AddChangeToTask < ActiveRecord::Migration
  def change
  	change_column :tasks, :importance, :integer, default: "2"
  end
end
