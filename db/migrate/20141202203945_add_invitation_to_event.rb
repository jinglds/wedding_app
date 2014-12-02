class AddInvitationToEvent < ActiveRecord::Migration
  def change
    add_column :events, :invitation_card, :string
  end
end
