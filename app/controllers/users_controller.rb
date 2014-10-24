class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :user_signed_in?, only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy
	def index
  		@users = User.paginate(page: params[:page])
	end
	
	def show
	    @user = User.find(params[:id])
	    @shops = @user.shops.paginate(page: params[:page])
	    # @events = @user.events.paginate(page: params[:page])
	    @ratings = (@user.get_up_voted Shop).paginate(page: params[:page])
	    @favorites = @user.favorite_shops.order('shops.created_at')
	end

	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User deleted."
	    redirect_to users_url
  	end

  	private
  	def correct_user
      	@user = User.find(params[:id])
      	redirect_to(root_url) unless current_user?(@user)
    end
	def admin_user
      redirect_to(root_url) unless admin?(current_user)
    end
end
