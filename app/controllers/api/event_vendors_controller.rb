module Api
  class EventVendorsController < Api::BaseController

    def index
      @event = Event.find(params[:event_vendor][:event_id])
      @vendors = @event.vendors
    end


  def get_event_vendors
    @event = Event.find(params[:event_vendor][:event_id])
    @vendors = @event.vendors
    @vendor = Vendor.new
  end

  	def create
  		
        # @task = Task.find(params[:task_id])
  		@vendor = Vendor.find(params[:event_vendor][:vendor_id])
  		@event = Event.find(params[:event_vendor][:event_id])

        if   EventVendor.create(:vendor_id => @vendor.id, :event_id => @event.id)
            return render :json=> {:success => true, :vendor => @vendor}
        else
          return render :json=> {:success => false, :message => "vendor not added to event"}
        end
    end

  	def remove_from_event
    	
      @vendor = Vendor.find(params[:vendor_id])
      @event = Event.find(params[:event_id])
    	EventVendor.where(vendor_id: @vendor.id, event_id: @event.id).first.destroy
      

    	return render :json=> {:success => false, :message => "vendor removed from event"}
        end
  end
end
