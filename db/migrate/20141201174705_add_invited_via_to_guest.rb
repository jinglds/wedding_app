class AddInvitedViaToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :invited_via, :string
  end
end
