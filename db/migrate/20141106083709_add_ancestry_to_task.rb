class AddAncestryToTask < ActiveRecord::Migration
   def self.up
    add_column :tasks, :ancestry, :string
    add_index :tasks, :ancestry
  end

  def self.down
    remove_index :tasks, :ancestry
    remove_column :tasks, :ancestry
  end
end