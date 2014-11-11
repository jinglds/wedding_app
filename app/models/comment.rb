class Comment < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :shop

  validates :content, presence: true
  validates :user_id, presence: true
  validates :shop_id, presence: true  


  # Returns shops from the users being followed by the given user.
  def self.in_shop(shop)
    comment_id = "SELECT id FROM comments
                          WHERE shop_id = :shop_id"
    where("id = :shop_id",
          shop_id: shop.id)
  end
  # def self.user_shop_vote(params)
  #   self.user.votes.find_by(:votable_id => params[:shop_id]).vote_weight
  # end
end
