class AddChangeToTask < ActiveRecord::Migration
  def change
  	change_column :tasks, :importance, :integern, default: "2"
  end
end
