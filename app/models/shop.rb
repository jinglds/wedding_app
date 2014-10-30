class Shop < ActiveRecord::Base
	acts_as_taggable # Alias for acts_as_taggable_on :tags
  	# acts_as_taggable_on :skills, :interests
  	# acts_as_token_authenticatable
  	
	acts_as_votable
	belongs_to :user
	has_many :comments, dependent: :destroy
	default_scope -> { order('created_at DESC') }
	before_save { self.email = email.downcase }
	validates :user_id, presence: true
	validates :shop_type, presence: true
	validates :name, presence: true
	validates :description, presence: true
	validates :phone, presence: true
	validates :address, presence: true
	validates :details, presence: true

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, 
  				format: { with: VALID_EMAIL_REGEX }
  	# 			uniqueness: { case_sensitive: false }

  	def comment_feed
	    Comment.where("shop_id =?", id)
	end

	def decoration
		Shop.where(shop_type: 'Decoration')
	end

	def photography
		Shop.where(shop_type: 'Photography')
	end

	def self.music
		Shop.where("shop_type = 'Music'")
	end

end


