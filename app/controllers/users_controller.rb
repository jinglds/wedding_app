class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :user_signed_in?, only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: [:destroy, :approve]
	def index
  		@users = User.paginate(page: params[:page])
	end
	
	def show
	    @user = User.find(params[:id])
	    @shops = @user.shops.paginate(page: params[:page])
	    @events = @user.events.paginate(page: params[:page])
	    @ratings = (@user.get_up_voted Shop).paginate(page: params[:page])
	    @favorites = @user.favorite_shops.order('shops.created_at')
	end

	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User deleted."
	    redirect_to users_url
  	end

  	def shops
  		@shops = current_user.shops

  	end

  	def events
  		@events = current_user.events
  	end
  	
  	def pendings

  		@pending_users = User.where(approval: 't').paginate(page: params[:page])
    end

  	

  	def approve
  		@user = User.find(params[:id])
	  	if @user.update_attributes(:approval => "f", :role => "enterprise")
	  		redirect_to :pendings, notice: "User approved"
    	else
      		render :pendings
   		end
	end

  	private
  	def correct_user
      	@user = User.find(params[:id])
      	redirect_to(root_url) unless current_user?(@user)
    end
	  def admin_user
      redirect_to(root_url) unless current_user.role=="admin"
    end


end
