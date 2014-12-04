class RenameCollaborators < ActiveRecord::Migration
  def change
  	rename_table :collaborators, :collaborations
  end
end
