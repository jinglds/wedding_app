class StaticPagesController < ApplicationController
  def home
  	@shop = current_user.shops.build if signed_in?
  end
 def vendors
    if signed_in?
      @vendor_feed_items = Shop.all.paginate(page: params[:page])
    end
  end
end
