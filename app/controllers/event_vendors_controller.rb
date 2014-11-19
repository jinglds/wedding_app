class EventVendorsController < ApplicationController

	def new

	  @vendor = Vendor.find(params[:vendor_id])
		@events = current_user.events
		# @event = Event.find(params[:event_id])
    # @task = Task.find(params[:task_id])
    @event_vendor = EventVendor.new
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
         flash[:success] = "Event Vendor added!"
         redirect_to :vendors
        
      else
        flash[:success] = "Error!"
          render 'new'
      end
  	end

	def destroy
  	
    @vendor = Vendor.find(params[:vendor_id])
    @event = Event.find(params[:event_id])
  	EventVendor.where(vendor_id: @vendor.id, event_id: @event.id).first.destroy
    

  	flash[:success] = "Event vender deleted!"
    redirect_to @event
	end
end
