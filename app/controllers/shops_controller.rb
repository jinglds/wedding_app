class ShopsController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


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

  private
  def shop_params
  	params.require(:shop).permit(:shop_type,
  								:name,
  								:description,
  								:phone,
  								:address,
  								:details,
                  :email)
  end


  def correct_user
        @shop = current_user.shops.find_by(id: params[:id])
        redirect_to root_url if @shop.nil?
  end
end
