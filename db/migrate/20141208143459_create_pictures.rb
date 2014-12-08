class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image_uid
      t.string :title
      t.integer :event_id
      t.boolean :cover, default: false

      t.timestamps
    end
  end
end
