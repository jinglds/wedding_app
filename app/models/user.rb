class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
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
