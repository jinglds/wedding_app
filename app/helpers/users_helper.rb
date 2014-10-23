module UsersHelper
	def admin?(user)
  		user.role=="admin"
  	end
end
