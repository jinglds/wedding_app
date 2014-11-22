module Api
  class GuestsController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
    before_filter :correct_user, only: [:destroy, :update, :pay, :unpay]

    def pay
      @guest = Guest.find(params[:guest_id])
      
      if (@guest.update_attributes(:paid => true))
        return render :json=> {:success => true, :message => "guest paid successfully"}
      else
        return render :json=> {:success => false, :message => "guest paid  unsuccessfully"}
      end
    end

    def unpay 
      @guest = Guest.find(params[:guest_id])
      if (@guest.update_attributes(:paid => false))
        return render :json=> {:success => true, :message => "guest unpaid  successfully"}
      else
        return render :json=> {:success => false, :message => "guest unpaid  unsuccessfully"}
      end
      
    end
   def create
      @event = Event.find(params[:event_id])
      @guest = @event.guests.build(guest_params)
      @guest.event = @event
      @guest.user = app_user

        if  @guest.save
          return render :json=> {:success => true, :guest => @guest}
        else
          return render :json=> {:success => false, :message => "guest not created"}
        end
      end

      def index
        @event = Event.find(params[:event_id])
        @guests = @event.guests
      end

      def show
        @event = Event.find(params[:event_id])
        @guest = Guest.find(params[:id])
        
      end

      def update
        @guest = Guest.find(params[:id])
        if @guest.update_attributes(guest_params)
          return render :json=> {:success => true, :guest => @guest}
        else
          return render :json=> {:success => false, :message => "error updating guest"}
        end
      end

      def destroy
        @guest = Guest.find(params[:id])
        if @guest.destroy
           return render :json=> {:success => true, :message => "guest deleted"}
        else
          return render :json=> {:success => false, :message => "error deleting guest"}
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

      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @guest = app_user.guests.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the guest owner"} if @guest.nil?
      end

    end
  end
