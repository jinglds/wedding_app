class SetDefaultToUser < ActiveRecord::Migration
  def change
  	change_column :articles, :published, :boolean, default: false
  	change_column :guests, :group, :string, default: "none"
  	add_column :guests, :attending, :boolean, default: false
  	add_column :guests, :invitation_sent, :boolean, default: false
  	remove_column :guests, :status
  end
end
