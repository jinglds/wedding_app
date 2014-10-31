class PhotosController < ApplicationController

	def show
		@photo = Photo.find(params[:id])
    	@shop = Shop.find(params[:shop_id])
    end

	def edit
		@photo = Photo.find(params[:id])
    	@shop = Shop.find(params[:shop_id])
	end
	def update
		@photo = Photo.find(params[:id])
	  respond_to do |format|
	    if @photo.update(photo_params)
	      format.html { redirect_to @photo.shop, notice: 'Post attachment was successfully updated.' }
	    end 
	  end
	end


	def destroy
      @shop= Shop.find(params[:shop_id])
      @photo = @shop.photos.find(params[:id])
      @photo.destroy

      flash[:success] = "Expense deleted!"
         redirect_to @shop
  end

	private
	def photo_params
    params.require(:photo).permit(:shop_id, :image)
  end

end
