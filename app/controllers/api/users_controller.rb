module Api
  class 
  	UsersController < Api::BaseController
  	acts_as_token_authentication_handler_for User

  	before_filter :authenticate_user!

	respond_to :json

	# GET /outlet_types
	def index
	    authorize! :read, User
	    users =  current_user.admin? ? User.all : [current_user]
	    render json: users, status: :ok
	end
  end
end