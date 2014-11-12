class AddDefaultCoverToPhotos < ActiveRecord::Migration
  def change
    change_column :photos, :cover, :boolean, default: false
  end
end
