class ChangeStringToText < ActiveRecord::Migration
  def change
  	change_column :articles, :content, :text
  	change_column :comments, :content, :text
  	change_column :users, :address, :text
  	change_column :guests, :address, :text
  	change_column :shops, :address, :text
  	change_column :shops, :description, :text
  	change_column :shops, :details, :text
  end
end
