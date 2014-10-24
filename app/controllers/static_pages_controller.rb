class StaticPagesController < ApplicationController
  def home
  	@shop = current_user.shops.build if signed_in?
  end
end
