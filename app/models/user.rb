class User < ActiveRecord::Base
	acts_as_voter
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	has_many :events
	has_many :shops, dependent: :destroy
	has_many :favorites
	has_many :favorite_shops, through: :favorites, source: :favorited, source_type: 'Shop'

	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable
	validates :firstname, presence: true
	validates :lastname, presence: true
	validates :address, presence: true
	validates :phone, presence: true
    after_create :assign_default_role

	def assign_default_role
		self.role = :client if self.role.blank?
	end

end