class VendorsController < ApplicationController


	def index
		# @event = Event.find(params[:event_id])
      @vendors = current_user.vendors
  	end
	def new
		@events = current_user.events
    unless params[:event_id].nil?
		  @event = Event.find(params[:event_id])
    end
		unless params[:shop_id].nil?
     		@shop = Shop.find(params[:shop_id])
     end
      # @task = Task.find(params[:task_id])
      @vendor = Vendor.new
  	end
	def create
		
      # @task = Task.find(params[:task_id])

      @vendor = current_user.vendors.build(vendor_params)

      if !params[:vendor][:event_id].nil?
        @event = Event.find(params[:vendor][:event_id])
        @vendor = current_user.vendors.create!(vendor_params)
        if EventVendor.create(:vendor_id => @vendor.id, :event_id => @event.id)
          flash[:success] = "Vendor added!"
          redirect_to @event
        else
          flash[:success] = "Error!"
          render 'new'
        end
      else
      # @vendor.task = @task
      # @vendor.shop = @shop
      # @vendor.user = current_user
      # @vendor.event = @event

        if @vendor.save
           flash[:success] = "Vendor added!"
           redirect_to :vendors
          
        else
          flash[:success] = "Error!"
            render 'new'
        end

      end
  	end

  	def show
	    @event = Event.find(params[:event_id])
	    @vendor = Vendors.find(params[:id])

	end


  	def destroy
	  	@vendor = current_user.vendors.find(params[:id])
	  	@vendor.destroy

	  	flash[:success] = "Vendor deleted!"
	    redirect_to vendors_path
  	end

	def edit
	    @vendor = Vendor.find(params[:id])
	end

	  def update
	    @vendor = Vendor.find(params[:id])

	    if @vendor.update_attributes(vendor_params)
	      redirect_to vendors_path, notice: "Successfully updated event"
	    else
	      render :edit
	    end
	  end

	  def add_to_event
	  	@vendor = Vendor.find(params[:id])
	  	@event = Event.find(params[:event_id])
	  end

  	private
  def vendor_params
  	params.require(:vendor).permit(:user_id,
  								:name,
                                :event_id,
                                :shop_id,
                                :task_id,
                                :phone,
                                :address,
                                :email,
                                :contact,
                                :note)


  end
end
