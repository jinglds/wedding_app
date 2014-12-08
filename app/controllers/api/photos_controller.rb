module Api
  class PhotosController < Api::BaseController

  	def index
	    
    	@shop = Shop.find(params[:shop_id])
    	@photos = @shop.photos
  	end

    def destroy
      @photo = Photos.find(params[:photo_id])
      if @photo.destroy
        return render :json=> {:success => true, :message=> 'Photo deleted successfully.'}
      else
        return render :json=> {:success => false, :message=> 'Photo not deleted.'}
      end
  end

  	

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
  
        if @picture.save
        	tempfile.delete
          return render :json=> {:success => true, :message=> 'Picture was successfully created.'}
        else
        	tempfile.delete
          
          return render :json=> {:success => false, :message=> 'Picture was not created.'}
        end
      
    end
	  private
	def photo_params
	    params.require(:photo).permit(:image, :title)
	end
  end
end
