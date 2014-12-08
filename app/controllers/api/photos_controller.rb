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
  	# def create
  	# 	@shop = Shop.find(params[:shop_id])
	  #   @photo = Photo.new(photo_params)
	  #   if @photo.save
	  #     render :json=> {:success => true, :photos => "yay"}
	  #   else
	  #     render :json=> {:success => false, :photos => "nay"}
	  #   end
	  # end
	#  def create
	#   	photo = DataFile.save(params[:upload])
	#     render :text => "File has been uploaded successfully"
	# end


	 def create
  	@shop = Shop.find(params[:shop_id])
      #check if file is within picture_path
      if params[:photo][:image]["file"]
           image_params = params[:photo][:image]
           #create a new tempfile named fileupload
           tempfile = Tempfile.new("fileupload")
           tempfile.binmode
           #get the file and decode it with base64 then write it to the tempfile
           tempfile.write(Base64.decode64(image_params["file"]))
     
           #create a new uploaded file
           uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "filename", :original_filename => "original_filename") 
     
           #replace picture_path with the new uploaded file
           params[:photo][:image] =  uploaded_file
     
      end
  
      @picture = @shop.photos.build(photo_params)
  
      respond_to do |format|
        if @picture.save
        	tempfile.delete
          format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
          format.json { render json: @picture, status: :created, location: @picture }
        else
        	tempfile.delete
          format.html { render action: "new" }
          format.json { render json: @picture.errors, status: :unprocessable_entity }
        end
      end
    end
	  private
	def photo_params
	    params.require(:photo).permit(:image, :title)
	end
  end
end
