class ShopsController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :client_user, only: [:new, :create, :destroy]

  # def index
  #   if signed_in?
  #     @vendor_feed_items = Shop.all.paginate(page: params[:page])
  #   end
  # end
  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.shops.build(shop_params)
    if @shop.save
      flash[:success] = "Shop created!"
      redirect_to @shop
    else
      render 'new'
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])

    if @shop.update_attributes(shop_params)
      redirect_to @shop, notice: "Successfully updated shop"
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to root_url
  end

  def show
    @user = current_user
    @shop = Shop.find(params[:id])
    @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
    @comment = Comment.new 
    @comments =  @shop.comment_feed.paginate(page: params[:page])
  end

  def rate
    @shop = Shop.find(params[:id])
    
    @shop.liked_by current_user, :vote_weight => params[:rating]

    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end


  def unrate
    @shop = Shop.find(params[:id])
    @shop.unliked_by current_user
   

    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end
  private
  def shop_params
    params.require(:shop).permit(:shop_type,
                  :name,
                  :description,
                  :phone,
                  :address,
                  :primary_contact,
                  :details,
                  :email)
  end


  def correct_user
        @shop = current_user.shops.find_by(id: params[:id])
        redirect_to root_url if @shop.nil?
  end

  def client_user
      redirect_to root_url if (current_user.role =="client")
  end

end

