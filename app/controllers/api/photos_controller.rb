module Api
  class PhotosController < Api::BaseController

  	def index
	    
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
  	end
  	
  end
end
