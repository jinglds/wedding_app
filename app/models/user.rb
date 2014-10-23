class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

    after_create :assign_default_role

	def assign_default_role
		add_role(:client) if self.roles.blank?
	end

end
