class AddApprovalToShop < ActiveRecord::Migration
  def change
    add_column :shops, :approval, :boolean, :default=>true
    add_column :shops, :attachment, :string
  end
end
