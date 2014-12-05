class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :admin_user, except:[:shops, :events, :show, :destroy]
  before_action :destroy, only: :destroy
	before_action :set_users, only:[:index, :approve, :set_admin]
  def index


    @users = @users.order(params[:sort])

    respond_to do |format|
      format.html 
      format.js
    end
	end

  # def category
  #   if params[:filter]=="enterprise"
  #     @users = User.enterprise_users
  #   elsif params[:filter]=="client"
  #     @users = User.client_users
  #   elsif params[:filter]=="pending"
  #     @users =  User.where(approval: 't').paginate(page: params[:page])
  #   else
  #     @users = User.all
  #   end


  #   respond_to do |format|
  #     format.html {render nothing:true}
  #     format.js
  #   end
  # end

  def set_admin 
      @user = User.find(params[:id])
      if @user.update_attributes(:role => "admin")
        flash[:success] ="User set as admin"
        redirect_to :users
      else
          render :users
      end
  end
	
	def show
	    @user = User.find(params[:id])
	    @shops = @user.shops.paginate(page: params[:page])
	    @events = @user.events.paginate(page: params[:page])
      @rated = @user.get_up_voted(Shop)
	    @favorites = @user.favorite_shops.order('shops.created_at')
	end


	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User deleted."
	    redirect_to users_url
  	end

  	def shops
  		@shops = current_user.shops
      # @favorite = Favorite.find_by_favorited_id(@shop.id)

  	end

  	def events
  		@events = current_user.events
      @col_ids = Collaboration.where(:user_id=> current_user.id).joined.pluck(:event_id).uniq
      @collaborations = Event.where('id in (?)', @col_ids)
      @req_ids = Collaboration.where(:user_id=> current_user.id).requests.pluck(:event_id).uniq
      @requests = Event.where('id in (?)', @req_ids)
  	end
  	
  	def pendings

  		@pending_users = User.where(approval: 't').paginate(page: params[:page])
    end

  	

  	def approve
  		@user = User.find(params[:id])
	  	@user.update_attributes(:approval => "f", :role => "enterprise")
	  	
      	# redirect_to :pendings, notice: "User approved"
    	# else
     #  		render :pendings
   		# end

      respond_to do |format|
        format.html {render nothing:true}
        format.js
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


    def set_users
      @filter = params[:filter]
      @e = User.enterprise_users
      @u = User.client_users
      @a = User.admin_users
      @p =User.pending_users
      if params[:filter]=="enterprise"
        @users = @e
      elsif params[:filter]=="client"
        @users = @u
      elsif params[:filter]=="admin"
        @users = @a
      elsif params[:filter]=="pending"
        @users =  @p
      else
        # @users = User.paginate(page: params[:page])
        @users = User.all
      end
      
    end
end
