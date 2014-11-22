class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.string :content
      t.string :category

      t.timestamps
    end
    add_index :articles, :user_id
  end
end
