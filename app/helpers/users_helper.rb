module UsersHelper
	def admin?(user)
		user.role=="admin"
	end
	def enterprise?(user)
		user.role=="enterprise"
	end
end
