class FavoriteShopsController < ApplicationController
  # before_action :set_shop
  before_filter :authenticate_user!
  
  def create
    @shop = Shop.find(params[:shop_id])
    Favorite.create(favorited: @shop, user: current_user)
    # if Favorite.create(favorited: @shop, user: current_user)
    #   redirect_to @shop, notice: 'Shop has been favorited'
    # else
    #   redirect_to @shop, alert: 'Something went wrong...*sad panda*'
    # end
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end

  end
  
  def destroy
    
    @shop = Shop.find(params[:id])
    Favorite.where(favorited_id: @shop.id, user_id: current_user.id).first.destroy
    # redirect_to @shop, notice: 'Shop is no longer in favorites'
    respond_to do |format|
      format.html {render nothing: true}
      format.js
    end

  end

  def index
    @user = current_user
      @fav_ids = Favorite.where(:user_id=>current_user.id).pluck(:favorited_id).uniq
      @shops = Shop.where(:id=> @fav_ids )
    
  end
  
  private
  
  def set_shop
    @shop = Shop.find(params[:id])
  end
end
