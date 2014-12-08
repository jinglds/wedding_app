class Shop < ActiveRecord::Base

	before_save :lowercase_params
	acts_as_taggable
  	acts_as_taggable_on :categories, :styles
  	# acts_as_token_authenticatable
  	
	acts_as_votable
	has_many :photos, dependent: :destroy
	accepts_nested_attributes_for :photos
	dragonfly_accessor :attachment do
	    default 'assets/images/shop-default.jpg'
	  end

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

	# validates :attachment, presence: true
	validates_size_of :attachment, maximum: 1024.kilobytes,
                  message: "should be no more than 1024 KB", if: :attachment_changed?
 	# validates_property :ext, of: :attachment, in: [:jpeg, :jpg, :png, :bmp, :pdf], case_sensitive: false,
  #                  message: "should be either .jpeg, .jpg, .png, .bmp, .pdf", if: :attachment_changed?
  validates_property :format, of: :attachment, in: [:jpeg, :jpg, :png, :bmp, :pdf], case_sensitive: false,
	                   message: "should be either .jpeg, .jpg, .png, .bmp, .pdf", if: :attachment_changed?


#     validate :maximum_amount_of_tags
# def maximum_amount_of_tags
# number_of_tags = tag_list_cache_on("tags").uniq.length
# errors.add(:base, "Please only add 5 interests") if number_of_tags > 5
# end

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, 
  				format: { with: VALID_EMAIL_REGEX }
  	# 			uniqueness: { case_sensitive: false }

  	scope :approved, -> { where(approval: 'f')}

  	def comment_feed
	    Comment.where("shop_id =?", id)
	end

	def lowercase_params
  		self.name.downcase!
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


