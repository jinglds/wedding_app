class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
    	t.belongs_to :event
      	t.belongs_to :user
      	t.boolean :accepted, :default => false
      	t.timestamps
    end

    add_index :collaborators, [:user_id, :event_id]
  end
end
