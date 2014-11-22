class GuestsController < ApplicationController

	def index
	    @event = Event.find(params[:event_id])
	    @guests = @event.guests
	    @total = @event.guests.count
	  end

	  def show
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:id])
	  end

	 def create
	      @event = Event.find(params[:event_id])
	      @guest = @event.guests.build(guest_params)
	      @guest.event = @event
	      @guest.user = current_user

	        # respond_to do |format|
	      if @guest.save
	         flash[:success] = "Guest created!"
	         redirect_to event_guests_path(@event)
	        
	      else
	        flash[:success] = "Error!"
	          render event_guests_path(@event)
	      end
	  end

	  def new
	      @event = Event.find(params[:event_id])
	      @guest = Guest.new
	  end

	  def destroy
	      @event= Event.find(params[:event_id])
	      @guest = @event.guests.find(params[:id])
	      @guest.destroy

	      flash[:success] = "Guest deleted!"
	         redirect_to event_guests_path(@event)
	  end

	  def edit
	    @guest = Guest.find(params[:id])
	    @event = Event.find(params[:event_id])
	  end

	  def update
	    @guest = Guest.find(params[:id])
	    @event = Event.find(params[:event_id])
	    if @guest.update_attributes(guest_params)
	      flash[:success] = "Successfully updated guest"
	      redirect_to event_guests_path(@event)
	    else
	      render :edit
	    end
	  end

	  private
	  def guest_params
	  	params.require(:guest).permit(:event_id,
  								:side,
  								:name,
  								:prefix,
  								:adults,
			                  	:children,
			                  	:phone,
			                  	:address,
			                  	:gender,
	                            :invitation_status,
	                            :attending,
			                  	:group,
                            	:table_no,
                            	:note,
			                  	:user_id)

	  end

	    def correct_user
	        @guest = current_user.guests.find_by(id: params[:id])
	        redirect_to root_url if @guest.nil?
	  end
end
