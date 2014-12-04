module Api
  class VendorsController < Api::BaseController
    # before_filter :verify_authenticity_token
    skip_before_filter :verify_authenticity_token, only: [:create]
     # load_and_authorize_resource
     # before_filter :verify_token, only: [:index, :show, :create]
     before_filter :correct_user, only: [:destroy, :update]

    def create
      @vendor = app_user.vendors.build(vendor_params)

      if (!params[:vendor][:event_id].nil? && params[:vendor][:event_id]!="")
          @event = Event.find(params[:vendor][:event_id])
          @vendor = current_user.vendors.create!(vendor_params)
        if EventVendor.create(:vendor_id => @vendor.id, :event_id => @event.id)
          return render :json=> {:success => true, :vendor => @vendor}
        else
          return render :json=> {:success => false, :message => "vendor not created"}
        end
      else
        if @vendor.save
          return render :json=> {:success => true, :vendor => @vendor}
        else
          return render :json=> {:success => false, :message => "vendor not created"}
        end
      end
    end

    def index
      @vendors = app_user.vendors
    
    end


    def show
      @vendor = Vendor.find(params[:id])
    end

    def update
      if @vendor.update_attributes(vendor_params)
        return render :json=> {:success => true, :vendor => @vendor}
      else
        return render :json=> {:success => false, :message => "error updating vendor"}
      end
    end

    def destroy
      @vendor = Vendor.find(params[:id])
      if @vendor.destroy
         return render :json=> {:success => true, :message => "vendor deleted"}
      else
        return render :json=> {:success => false, :message => "error deleting vendor"}
      end
    end

 

    private

      def vendor_params
        params.require(:vendor).permit(:user_id,
                                :name,
                                # :event_id,
                                :shop_id,
                                :task_id,
                                :phone,
                                :address,
                                :email,
                                :contact,
                                :note)

      end


      def verify_token
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
        token = request.headers['X-User-Token'].to_s
        
        # token_user = User.find_by_authentication_token(token)
          return render :json=> {:error=>"Error with your email"} unless user
        
          return render :json=> {:error=>"Error with your authentication token"} unless (user.authentication_token==token)
        
      end

      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @vendor = app_user.vendors.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the vendor owner"} if @vendor.nil?
      end



  end
end

