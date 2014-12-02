class GuestsController < ApplicationController
	before_filter :authenticate_user!, except: [:attending_rsvp, :invitation_form]
	before_action :correct_user,   only: [:destroy, :edit, :update, :attending, :invitation_sent]
	before_action :event_user, only: [:index, :create, :manage_tables, :invitation, :update_all, :set_table, :clear_table]

	def invitation_form
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:guest_id])

	    respond_to do |format|
	      format.html 
	      format.js
    	end
	end

	def attending_rsvp
	    @guest = Guest.find(params[:guest_id])
	    @guest.update_attributes(:adults=>params[:adults], :children=>params[:children], :attending => params[:attending], :invitation_sent => params[:invitation_sent], :responded=>true) 
	    respond_to do |format|
	      format.html {render nothing: true}
	      format.js
    	end
	end


	def attending
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:guest_id])
	    @guest.update_attributes(:attending => params[:attending], :invitation_sent => params[:invitation_sent]) 
	    redirect_to event_guests_invitation_path
	end

	def invitation_sent
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:guest_id])
	    @guest.update_attributes(:invitation_sent => params[:invitation_sent]) 
	    redirect_to event_guests_invitation_path
	end

	def update_all
	    @event = Event.find(params[:event_id])
		params["guest"].keys.each do |id|
			@guest = Guest.find(id.to_i)
			@guest.update_attributes(guests_params(id))
		end
			
		redirect_to event_guests_manage_tables_path(:event_id=>@event.id)
	end



	def set_table
	    @event = Event.find(params[:event_id])
	    @guest = Guest.find(params[:guest_id])
		@guest.update_attributes(:table_no => params[:table_no])
		redirect_to event_guests_manage_tables_path(:event_id=>@event.id)

	end

	def clear_table
	    @event = Event.find(params[:event_id])
		@guests = @event.guests
		@guests.update_all(:table_no => params[:table_no])
		redirect_to event_guests_manage_tables_path(:event_id=>@event.id)
	end
	def manage_tables
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

	    
	    @unsets = @guests.where(:table_no=>0)
	    if params[:sort].nil? || params[:sort]==""
	    	@unsets = @unsets.order(:name)
	    else
	    	@unsets = @unsets.order(params[:sort])
	    end
	    @groups = Guest.where(:event_id=>@event.id).uniq.pluck(:group)
	    @tables = Guest.where(:event_id=>@event.id).order(:table_no).uniq.pluck(:table_no)
	end

	def invitation
		@new = Guest.new
	    @event = Event.find(params[:event_id])
	    @guests = @event.guests
	    @all_guests = @event.guests


	    unless params[:status].nil? || params[:status]==""
	    	if params[:status]=="invited"
	    		@guests = @guests.inviteds
	    	elsif params[:status]=="attending"
	    		@guests = @guests.attendees
	    	elsif params[:status]=="declined"
	    		@guests = @guests.declines
	    	else 
	    		@guests = @guests.respondeds
	    	end
	    end
	    unless params[:group].nil? || params[:group]==""
	    	@guests = @guests.where(:group =>params[:group])
	    end

	    unless params[:side].nil? || params[:side] ==""
	    	@guests = @guests.where(:side =>params[:side])
	    end

	    unless params[:table].nil? || params[:table] ==""
	    	@guests = @guests.where(:table_no =>params[:table])
	    end
	    if params[:sort].nil? || params[:sort]==""
	    	@guests = @guests.order(:name)
	    else
	    	@guests = @guests.order(params[:sort])
	    end
	    @total = @event.guests.count
	    @groups = Guest.where(:event_id=>@event.id).uniq.pluck(:group)
	    @tables = Guest.where(:event_id=>@event.id).order(:table_no).uniq.pluck(:table_no)


	    respond_to do |format|
	      format.html
	      format.csv { send_data @guests.to_csv }
	      format.xls 
	    end
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

	    unless params[:table].nil? || params[:table] ==""
	    	@guests = @guests.where(:table_no =>params[:table])
	    end
	    if params[:sort].nil? || params[:sort]==""
	    	@guests = @guests.order(:name)
	    else
	    	@guests = @guests.order(params[:sort])
	    end
	    @total = @event.guests.count
	    @groups = Guest.where(:event_id=>@event.id).uniq.pluck(:group)
	    @tables = Guest.where(:event_id=>@event.id).order(:table_no).uniq.pluck(:table_no)


	    respond_to do |format|
	      format.html
	      format.csv { send_data @guests.to_csv }
	      format.xls 
	    end
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
	    @new = Guest.find(params[:id])
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

	  def guests_params(id)
		params.require(:guest).fetch(id).permit( :side,
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
                            	:note)

	end
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
	                            :invited_via,
	                            :attending,
			                  	:group,
                            	:table_no,
                            	:note,
			                  	:user_id)

	  end

	def correct_user
	        @guest = current_user.guests.find_by(id: params[:id] || params[:guest_id])
	        redirect_to root_url if @guest.nil?
	end
	def event_user
      @event = current_user.events.find_by(id: params[:id] || params[:event_id])
      redirect_to root_url if @event.nil?
    end
end
