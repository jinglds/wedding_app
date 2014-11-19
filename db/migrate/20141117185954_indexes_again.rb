class IndexesAgain < ActiveRecord::Migration
  def self.up
    add_index :comments, :user_id
    add_index :votes, :voter_id
    add_index :votes, :votable_id
    add_index :taggings, [:tag_id, :taggable_id]
  end
end
