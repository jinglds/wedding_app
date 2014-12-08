class PicturesController < ApplicationController

	
    skip_before_filter :verify_authenticity_token, only: [:create]
	def index
	    
    	@event = Event.find(params[:event_id])
    	@pictures = @event.pictures
  	end
 
  	def new
    	@picture = Picture.new
    	@event = Event.find(params[:event_id])
  	end

  	def new_gallery
    	@picture = Picture.new
    	@event = Event.find(params[:event_id])
  	end
 
  	def create
 

  		@event = Event.find(params[:event_id])
    	# @picture = @event.pictures.build(picture_params)

    	unless params[:images].nil?
            params[:images].each do |a|
            	# if @event.pictures << Picture.create(:image => a)
        		# @event.pictures.create(:image => a)
	      #   		render 'new'
		   		# end
		   		@picture = @event.pictures.build(:image => a)
		   		unless  @picture.save
		   			
	    			flash[:danger] = @picture.errors.full_messages.to_sentence
		   		end

        	end
        	# redirect_to event_pictures_path
        end
        if no_cover?
        	@event.pictures.first.update_attributes(:cover => true)
        end
    	# if @picture.save
	    #   flash[:success] = "Picture saved!"
	      redirect_to event_pictures_path
	    # else
	      # render 'new'
	    # end
  	end

  	def update
  		@event = Event.find(params[:event_id])
  		@picture = Picture.find(params[:id])
	    if @picture.update(picture_params)
	    	flash[:success] = "picture updated!"
	      redirect_to event_pictures_path(@event)
	    end 
	  
	end

	def edit_gallery
  		@event = Event.find(params[:event_id])
		@pictures = @event.pictures
	end


	# def show
	# 	@picture = Picture.find(params[:id])
 #    	@event = Event.find(params[:event_id])
 #    end

	def edit

		@picture = Picture.find(params[:id])
    	@event = Event.find(params[:event_id])
    	@pictures = @event.pictures
	end

	# def edit_gallery
 #    	@event = Event.find(params[:event_id])
 #    	@pictures = @event.pictures
	# end

	def set_as_cover
		@event = Event.find(params[:event_id])
		@picture = Picture.find(params[:id])
    	@pictures = @event.pictures
    	if @pictures.where(:cover => true).first
    		@pictures.where(:cover => true).first.update_attributes(:cover => false)
    	end
    	if @picture.update_attributes(:cover => true)
		redirect_to @event, notice: "Set as cover "
    	else
      		render :set_as_cover
   		end
    
	end
	# def update
 #     	 @event= Event.find(params[:event_id])
	# 	@picture = Picture.find(params[:id])
	# 	  respond_to do |format|
	# 	    if @picture.update(picture_params)
	# 	      format.html { redirect_to @picture.event, notice: 'Post attachment was successfully updated.' }
	# 	    end 
	# 	  end
	# end


	def destroy
      @event= Event.find(params[:event_id])
      @picture = @event.pictures.find(params[:id])
      @picture.destroy

      flash[:success] = "event deleted!"
         redirect_to event_pictures_path
  end

	private
	def picture_params
	    params.require(:picture).permit(:image, :title)
	end

	def no_cover?
		Picture.is_cover(:event_id => @event.id).nil?
	end

end
