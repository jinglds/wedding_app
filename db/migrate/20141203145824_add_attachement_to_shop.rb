class AddAttachementToShop < ActiveRecord::Migration
  def change
  	rename_column :shops, :attachment, :attachment_uid
  end
end
