class ShopsController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # def index
  #   if signed_in?
  #     @vendor_feed_items = Shop.all.paginate(page: params[:page])
  #   end
  # end 
  def create
    @shop = current_user.shops.build(shop_params)
    if @shop.save
      flash[:success] = "Shop created!"
      redirect_to root_url
    else
      render'static_pages/home'
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
    # @comment = Comment.new 
    # @comment_items =  @shop.comment_feed.paginate(page: params[:page], per_page: 10)
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
end

