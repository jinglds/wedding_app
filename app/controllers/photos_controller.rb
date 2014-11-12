class PhotosController < ApplicationController


	def index
	    
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
  	end
 
  	def new
    	@photo = Photo.new
    	@shop = Shop.find(params[:shop_id])
  	end

  	def new_gallery
    	@photo = Photo.new
    	@shop = Shop.find(params[:shop_id])
  	end
 
  	def create
 

  		@shop = Shop.find(params[:shop_id])
    	# @photo = @shop.photos.build(photo_params)

    	unless params[:images].nil?
            params[:images].each do |a|
            	# if @shop.photos << Photo.create(:image => a)
        		# @shop.photos.create(:image => a)
	      #   		render 'new'
		   		# end
		   		@photo = @shop.photos.build(:image => a)
		   		unless  @photo.save
		   			
	    			flash[:danger] = @photo.errors.full_messages.to_sentence
		   		end

        	end
        	# redirect_to shop_photos_path
        end
        if no_cover?
        	@shop.photos.first.update_attributes(:cover => true)
        end
    	# if @photo.save
	    #   flash[:success] = "Photo saved!"
	      redirect_to shop_photos_path
	    # else
	      # render 'new'
	    # end
  	end

  	def update
  		@shop = Shop.find(params[:shop_id])
  		@photo = Photo.find(params[:id])
	    if @photo.update(photo_params)
	    	flash[:success] = "photo updated!"
	      redirect_to shop_edit_gallery_path(@shop)
	    end 
	  
	end

	def edit_gallery
  		@shop = Shop.find(params[:shop_id])
		@photos = @shop.photos
	end


	# def show
	# 	@photo = Photo.find(params[:id])
 #    	@shop = Shop.find(params[:shop_id])
 #    end

	def edit

		@photo = Photo.find(params[:id])
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
	end

	# def edit_gallery
 #    	@shop = Shop.find(params[:shop_id])
 #    	@photos = @shop.photos
	# end

	def set_as_cover
		@shop = Shop.find(params[:shop_id])
		@photo = Photo.find(params[:id])
    	@photos = @shop.photos
    	if @photos.where(:cover => true).first
    		@photos.where(:cover => true).first.update_attributes(:cover => false)
    	end
    	if @photo.update_attributes(:cover => true)
		redirect_to @shop, notice: "Set as cover "
    	else
      		render :set_as_cover
   		end
    
	end
	# def update
 #     	 @shop= Shop.find(params[:shop_id])
	# 	@photo = Photo.find(params[:id])
	# 	  respond_to do |format|
	# 	    if @photo.update(photo_params)
	# 	      format.html { redirect_to @photo.shop, notice: 'Post attachment was successfully updated.' }
	# 	    end 
	# 	  end
	# end


	def destroy
      @shop= Shop.find(params[:shop_id])
      @photo = @shop.photos.find(params[:id])
      @photo.destroy

      flash[:success] = "shop deleted!"
         redirect_to shop_photos_path
  end

	private
	def photo_params
	    params.require(:photo).permit(:image)
	end

	def no_cover?
		Photo.is_cover(:shop_id => @shop.id).nil?
	end

end
