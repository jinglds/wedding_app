class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image_uid
      t.string :title
      t.string :shop_id
      t.boolean :cover

      t.timestamps
    end
  end
end
