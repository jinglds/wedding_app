module Api
  class PhotosController < Api::BaseController

  	def index
	    
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
  	end

  	# def create
 

  	# 	@shop = Shop.find(params[:shop_id])
   #  	# @photo = @shop.photos.build(photo_params)

   #  	unless params[:photo][:images].nil?
   #          params[:photo][:images].each do |a|
   #          	# if @shop.photos << Photo.create(:image => a)
   #      		# @shop.photos.create(:image => a)
	  #     #   		render 'new'
		 #   		# end
		 #   		@photo = @shop.photos.build(:image => a)
		 #   		unless  @photo.save
		   			
	  #   			flash[:danger] = @photo.errors.full_messages.to_sentence
		 #   		end

   #      	end
   #      	# redirect_to shop_photos_path
   #      end
   #      if no_cover?
   #      	@shop.photos.first.update_attributes(:cover => true)
   #      end
   #  	return render :json=> {:success => true, :photos => @shop.photos}

  	# end
  	def create
  		@shop = Shop.find(params[:shop_id])
	    @photo = Photo.new(photo_params)
	    if @photo.save
	      render :json=> {:success => true, :photos => @photo.url}
	    else
	      render :json=> {:success => false, :photos => @photo.url}
	    end
	  end

	  private
	def photo_params
	    params.require(:photo).permit(:image, :title)
	end
  end
end
