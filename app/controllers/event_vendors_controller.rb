class EventVendorsController < ApplicationController
  before_filter :authenticate_user!
  before_action :correct_user,   only: [:destroy]
  before_action :collaborator, except: [:destroy, :new]
  

	def new

	  @vendor = Vendor.find(params[:vendor_id])
    @event_vendor_ids = EventVendor.where(:vendor_id =>@vendor.id).pluck(:event_id).uniq
		@events = current_user.events.where('id not in (?)',@event_vendor_ids)
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

  private
     def collaborator
    @myevent = current_user.events.find_by( params[:event_id])
    @event = Event.find_by(Collaboration.where(:id=> (params[:event_id]), :user_id=>current_user.id, :accepted=>true))
    redirect_to root_url if (@event.nil? && @myevent.nil?)
  end
    def correct_user
          @event_vendor = current_user.event_vendors.find_by(id: params[:id] || params[:event_vendor_id])
          redirect_to root_url if @event_vendor.nil?
  end
end
