module Api
  class PicturesController < Api::BaseController

  	def index
	    
    	@event = Event.find(params[:event_id])
    	@pictures = @event.pictures
  	end

    def destroy
      @picture = Pictures.find(params[:id])
      if @picture.destroy
        return render :json=> {:success => true, :message=> 'Picture deleted successfully.'}
      else
        return render :json=> {:success => false, :message=> 'Picture not deleted.'}
      end
  end

  	

	 def create
  	@event = Event.find(params[:event_id])
      #check if file is within picture_path
      if params[:picture][:image]["file"]
           image_params = params[:picture][:image]
           #create a new tempfile named fileupload
           tempfile = Tempfile.new("fileupload")
           tempfile.binmode
           #get the file and decode it with base64 then write it to the tempfile
           tempfile.write(Base64.decode64(image_params["file"]))
     
           #create a new uploaded file
           uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "filename", :original_filename => "original_filename") 
     
           #replace picture_path with the new uploaded file
           params[:picture][:image] =  uploaded_file
     
      end
  
      @picture = @event.pictures.build(picture_params)
  
        if @picture.save
        	tempfile.delete
          return render :json=> {:success => true, :message=> 'Picture was successfully created.'}
        else
        	tempfile.delete
          
          return render :json=> {:success => false, :message=> 'Picture was not created.'}
        end
      
    end
	  private
	def picture_params
	    params.require(:picture).permit(:image, :title)
	end
  end
end
