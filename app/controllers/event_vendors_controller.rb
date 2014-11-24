class EventVendorsController < ApplicationController

	def new

	  @vendor = Vendor.find(params[:vendor_id])
		@events = current_user.events
		# @event = Event.find(params[:event_id])
    # @task = Task.find(params[:task_id])
    @event_vendor = EventVendor.new
  end
  def index
    @event = Event.find(params[:event_id])
    @vendors = @event.vendors
    @vendor = Vendor.new
    @events = current_user.events
  end

	def create
		
      # @task = Task.find(params[:task_id])
		@vendor = Vendor.find(params[:event_vendor][:vendor_id])
		@event = Event.find(params[:event_vendor][:event_id])
      	# @vendor.events << @event
      	# @event.vendors << @vendor
      # @vendor.task = @task
      # @vendor.shop = @shop
      # @vendor.user = current_user
      # @vendor.event = @event

      if EventVendor.create(:vendor_id => @vendor.id, :event_id => @event.id)
         flash[:success] = "Vendor added to event!"
         redirect_to event_vendors_path(:event_id=>@event.id)
        
      else
        flash[:success] = "Error!"
          render 'new'
      end
  	end

	def destroy
  	
    @vendor = Vendor.find(params[:id])
    @event = Event.find(params[:event_id])
  	EventVendor.where(vendor_id: @vendor.id, event_id: @event.id).first.destroy
    

  	flash[:success] = "Vendor removed from event!"
    redirect_to event_vendors_path(:event_id=>@event.id)
	end
end
