class AddPublishedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :boolean
    add_index :articles, [:published, :category]
  end
end
