class AddApprovalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approval, :boolean, default: false
    change_column :users, :role, :string, default: "client"
  end
end
