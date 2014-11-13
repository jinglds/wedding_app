class AddGuestToEvent < ActiveRecord::Migration
  def change
    add_column :events, :guest_amt, :integer
  end
end
