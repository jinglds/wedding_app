class RemoveUserIdFromExpense < ActiveRecord::Migration
  def change
    remove_column :expenses, :user_id, :integer
  end
end
