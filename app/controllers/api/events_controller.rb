module Api
  class EventsController < Api::BaseController
    # before_filter :verify_authenticity_token
    skip_before_filter :verify_authenticity_token, only: [:create]
     # load_and_authorize_resource
     # before_filter :verify_token, only: [:index, :show, :create]
     before_filter :correct_user, only: [:destroy, :update]
 # before_filter :set_date, only: [:create, :update]

    def create
        params[:event][:date] = Chronic.parse(params[:event][:date])
        @event = app_user.events.build(event_params)
      if  @event.save
        return render :json=> {:success => true, :event => @event}
      else
        return render :json=> {:success => false, :message => "event not created"}
      end
    end

    def index
      @events = app_user.events.all
      # @events = Event.all
      # @related = Event.tagged_with(@event.style_list, :any => true, :order_by_matching_tag_count => true).limit(5)
      
    end

  

    def show
      @event = Event.find(params[:id])
      @expenses = @event.expenses
      @total = @event.expenses.sum(:amount)
      @tasks = @event.tasks
    end

    def update

      params[:event][:date] = Chronic.parse(params[:event][:date])
      if @event.update_attributes(event_params)
        return render :json=> {:success => true, :event => @event}
      else
        return render :json=> {:success => false, :message => "error updating event"}
      end
    end

    def destroy
      @event = Event.find(params[:id])
      if @event.destroy
         return render :json=> {:success => true, :message => "event deleted"}
      else
        return render :json=> {:success => false, :message => "error deleting event"}
      end
    end

    

    private

      def event_params
    params.require(:event).permit(:name,
                  :event_type,
                  :date,
                  :time,
                  :budget,
                  :bride_name,
                  :groom_name)
  end

  def set_date
    @date = DateTime.parse(params[:event][:date])
    @time = DateTime.parse(params[:event][:time])
    @date = @date.change(hour: @time.hour, min: @time.min, sec: @time.sec)
    params[:event][:date] =@date
  end

      def query_params
        # this assumes that an album belongs to an artist and has an :artist_id
        # allowing us to filter by this
        # params.permit(:category_list, :style_list)
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
        @event = app_user.events.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the event owner"} if @event.nil?
      end



  end
end

