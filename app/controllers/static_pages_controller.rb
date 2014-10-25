class StaticPagesController < ApplicationController
  def home
  	@shop = current_user.shops.build if signed_in?
  	@event = current_user.events.build if signed_in?

  end
 def vendors
    if signed_in?
      @shops = Shop.all.paginate(page: params[:page])
    end
  end
end
