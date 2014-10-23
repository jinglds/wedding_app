class Shop < ActiveRecord::Base
	belongs_to :user
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
  	# validates :email, presence: true, 
  	# 			format: { with: VALID_EMAIL_REGEX },
  	# 			uniqueness: { case_sensitive: false }

end

