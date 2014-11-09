class PhotosController < ApplicationController

	def show
		@photo = Photo.find(params[:id])
    	@shop = Shop.find(params[:shop_id])
    end

	def edit

		@photo = Photo.find(params[:id])
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
	end

	def edit_gallery
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
	end

	def set_as_cover
		@shop = Shop.find(params[:shop_id])
		@photo = Photo.find(params[:id])
    	@photos = @shop.photos
    	if @photos.where(:cover => true).first
    		@photos.where(:cover => true).first.update_attributes(:cover => false)
    	end
    	if @photo.update_attributes(:cover => true)
    		@shop.update_attributes(:cover_url => @photo.image) 
		redirect_to @shop, notice: "Set as cover "
    	else
      		render :set_as_cover
   		end
    
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
    params.require(:photo).permit(:shop_id, :image, :cover)
  end

end
