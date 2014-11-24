class Shop < ActiveRecord::Base
	acts_as_taggable
  	acts_as_taggable_on :categories, :styles
  	# acts_as_token_authenticatable
  	
	acts_as_votable
	has_many :photos, dependent: :destroy
	accepts_nested_attributes_for :photos
	belongs_to :user
	has_many :vendors
	has_many :comments, dependent: :destroy
	default_scope -> { order('created_at DESC') }
	before_save { self.email = email.downcase }
	validates :user_id, presence: true
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


	def rate(params)
	    @shop = Shop.find(params[:shop_id])
	    
	    @shop.liked_by current_user, :vote_weight => params[:rating]

	    respond_to do |format|
	      format.html { redirect_to @shop }
	      format.js
	    end
	end

	def self.search(query)
	  where("name like ?", "%#{query}%") 
	end

end


