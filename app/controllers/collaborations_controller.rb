class CollaborationsController < ApplicationController

	def accept
	    @collaboration = Collaboration.find(params[:collaboration_id])
	    
	    @collaboration.update_attributes(:accepted => true) 
	    redirect_to event_path(@collaboration.event)
	end

	def new
	    @event = Event.find(params[:event_id])
	    @collaboration = Collaboration.new
	end
  def index
    @event = Event.find(params[:event_id])
    @users = @event.users
    @user = User.new
    @events = current_user.events
  end

	def create
		
		@user = User.find_by_email(params[:collaboration][:user_id])
		@event = Event.find(params[:collaboration][:event_id])

		if @user.nil?
			flash[:danger] = "No user with that email"
        	redirect_to new_collaboration_path(:event_id=>@event.id)
      	else
      		@col = Collaboration.where(:user_id=>@user.id, :event_id=>@event.id).first
      		if @col.nil?
      			if @user ==current_user
			    	flash[:danger] = "You are the owner of the event!"
			        redirect_to new_collaboration_path(:event_id=>@event.id)
			    else
			    	params[:collaboration][:user_id] = @user.id
			        if Collaboration.create!(collaboration_params)
			        	flash[:success] = "Collaboration request sent!"
			        	redirect_to event_path(@event)
			        
			     	else
			        	flash[:danger] = "Error!"
			        	render 'new'
			      	end
			     end
		    else
		    	flash[:danger] = "Request already sent to that email!"
		         redirect_to new_collaboration_path(:event_id=>@event.id)
		    end
	  	end
  	end

	def destroy
  	
	  	Collaboration.where(:id=>params[:id]).first.destroy
	    

	  	flash[:success] = "User removed from event!"
	    redirect_to myevents_path
	end

	private
  def collaboration_params
  	params.require(:collaboration).permit(:event_id, :user_id, :accepted)
  end
end
