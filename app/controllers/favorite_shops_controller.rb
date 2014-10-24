class FavoriteShopsController < ApplicationController
  before_action :set_shop
  
  def create
    if Favorite.create(favorited: @shop, user: current_user)
      redirect_to @shop, notice: 'Shop has been favorited'
    else
      redirect_to @shop, alert: 'Something went wrong...*sad panda*'
    end
  end
  
  def destroy
    Favorite.where(favorited_id: @shop.id, user_id: current_user.id).first.destroy
    redirect_to @shop, notice: 'Shop is no longer in favorites'
  end
  
  private
  
  def set_shop
    @shop = Shop.find(params[:shop_id] || params[:id])
  end
end
