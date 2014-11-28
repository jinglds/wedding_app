class GuestsController < ApplicationController

	def set_table
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:guest_id])
		@guest.update_attributes(:table_no => params[:table_no])
		redirect_to event_guests_path
	end

	def clear_table
	    @event = Event.find(params[:event_id])
		@guests = @event.guests
		@guests.update_all(:table_no => params[:table_no])
		redirect_to event_guests_path
	end

	def index
		@new = Guest.new
	    @event = Event.find(params[:event_id])
	    @guests = @event.guests
	    @all_guests = @event.guests

	    unless params[:group].nil? || params[:group]==""
	    	@guests = @guests.where(:group =>params[:group])
	    end

	    unless params[:side].nil? || params[:side] ==""
	    	@guests = @guests.where(:side =>params[:side])
	    end
	    @unsets = @guests.where(:table_no=>0).order(:name)
	    @total = @event.guests.count
	    @groups = Guest.where(:event_id=>@event.id).uniq.pluck(:group)
	    @tables = Guest.where(:event_id=>@event.id).order(:table_no).uniq.pluck(:table_no)
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
	      @new = Guest.new
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
	                            :invitation_sent,
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
