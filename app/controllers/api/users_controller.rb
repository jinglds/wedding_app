module Api
  class 
  	UsersController < Api::BaseController
  	# acts_as_token_authentication_handler_for User

     before_filter :verify_token, only: [:index, :app_user]

  	# before_filter :authenticate_user!

	# respond_to :json

	# GET /outlet_types
	def index
	    authorize! :read, User
	    users =  current_user.admin? ? User.all : [current_user]
	    render json: users, status: :ok
	end

	def shops
		@shops = app_user.shops
	end


	private
	def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
    end


    def verify_token
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
        token = request.headers['X-User-Token'].to_s
        
        # token_user = User.find_by_authentication_token(token)
          return render :json=> {:error=>"Error with your email"} unless user
        
          return render :json=> {:error=>"Error with your authentication token"} unless (user.authentication_token==token)
        
    end
  end
end