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

    def clear_tasks
      @event = Event.find(params[:event_id])
      if Task.destroy_all(:event_id=>@event.id)
         return render :json=> {:success => true, :message => "tasks cleared"}
      else
        return render :json=> {:success => false, :message => "error clearing event"}
      end
      
    end

    def create_default_tasks
    @event = Event.find(params[:event_id])
    @date = @event.date
    @user = app_user
    if @event.tasks.create([{:title => "Choose a theme for the Wedding",
                        :due_date => @date.months_ago(6),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "tips: ",
                        :tag_list => "guest",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent_id => ""},

                        {:title => "Confirm number of guests",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "guest",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Create a Guest List",
                              :due_date => @date.months_ago(6),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "guest",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id =>"")},

                        {:title => "Confirm event date and number of guests with Wedding Venue",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "venue",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Wedding Venue",
                              :due_date => @date.months_ago(6),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "venue",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Wedding Venues",
                                      :due_date => @date.months_ago(6),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "tips: The budget and the number of guests will be factors in choosing the wedding venue.",
                                      :tag_list => "venue",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id =>""))},
                        {:title => "Confirm Menu and number of Guests with Caterer",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "caterer, food",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Choose Menus with Caterer",
                              :due_date => @date.months_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "caterer, food",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose wedding day Caterer",
                                      :due_date => @date.months_ago(6),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "tips: The food to be served depends on the number of guests and could be provided by the venue or outside caterers.",
                                      :tag_list => "caterer, food",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id => ""))},

                        {:title => "Pick up and Setup Wedding Cake at the Venue",
                        :due_date => @date.days_ago(1),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
                        :note => "",
                        :tag_list => "wedding cake, venue",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Confirm on Wedding Cake order",
                              :due_date => @date.months_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "wedding cake",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                @event.tasks.create(:title => "Decide on & Order Wedding Cake",
                                    :due_date => @date.months_ago(6),
                                    :completed => false,
                                    :redo => false,
                                    :reminder => "",
                                    :optional => false,
                                    :note => "",
                                    :tag_list => "wedding cake",
                                    :importance => 2,
                                    :rank => 0,
                                    :event_id => @event.id,
                                    :user_id => @user.id,
                                    :parent_id =>""))}, 

                        {:title => "Pick Up Wedding Attire",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "attire",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Final Attire fitting and makeup",
                              :due_date => @date.weeks_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "attire",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                @event.tasks.create(:title => "Do fitting for attire",
                                    :due_date => @date.months_ago(2),
                                    :completed => false,
                                    :redo => true,
                                    :reminder => "",
                                    :optional => false,
                                    :note => "",
                                    :tag_list => "attire",
                                    :importance => 2,
                                    :rank => 1,
                                    :event_id => @event.id,
                                    :user_id => @user.id,
                                    :parent =>
                                        @event.tasks.create(:title => "Choose Wedding Attire for bride, grooms, and attendees",
                                            :due_date => @date.months_ago(6),
                                            :completed => false,
                                            :redo => false,
                                            :reminder => "",
                                            :optional => false,
                                            :note => "",
                                            :tag_list => "attire",
                                            :importance => 2,
                                            :rank => 0,
                                            :event_id => @event.id,
                                            :user_id => @user.id,
                                            :parent_id => "")))},

                        {:title => "Pick Up Wedding Ring",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "rings",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Choose Wedding/Engagement Rings",
                              :due_date => @date.months_ago(6),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "rings",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id => "")},

                        {:title => "Confirm date and time with Makeup Artist and Hairstylist",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "makeup, hair",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Makeup Artist and Hairstylist",
                              :due_date => @date.months_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "makeup, hair",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Makeup Artist and Hairstylist",
                                      :due_date => @date.months_ago(6),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "",
                                      :tag_list => "makeup, hair",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id => ""))}, 

                        {:title => "Confirm date and time with Photographers and Cinematographer",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "photo, photograpny, cinematography",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Photographers and Cinematographer",
                              :due_date => @date.months_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "photo, photograpny, cinematography",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Photographers and Cinematographer",
                                      :due_date => @date.months_ago(6),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "",
                                      :tag_list => "photo, photograpny, cinematographer",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id => ""))}, 

                        {:title => "Pick Up Prewedding photos",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
                        :note => "",
                        :tag_list => "photo, photography",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Shoot Prewedding photos",
                              :due_date => @date.months_ago(6),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "photo, photography",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id => "")},  

                        {:title => "Send out Invitation Cards",
                        :due_date => @date.months_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "invitation cards, cards",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Print out / Pickup Invitation Cards",
                              :due_date => @date.months_ago(2),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "invitation cards, cards",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Confirm Invitation Cards order",
                                      :due_date => @date.months_ago(3),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "tips: You can choose to design the invitation card on their own or customize from the catalog from the card shop.",
                                      :tag_list => "invitation cards, cards",
                                      :importance => 2,
                                      :rank => 1,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent =>
                                        @event.tasks.create(:title => "Decide on Invitation Cards design",
                                            :due_date => @date.months_ago(3),
                                            :completed => false,
                                            :redo => false,
                                            :reminder => "",
                                            :optional => false,
                                            :note => "",
                                            :tag_list => "invitation cards, cards",
                                            :importance => 2,
                                            :rank => 0,
                                            :event_id => @event.id,
                                            :user_id => @user.id,
                                            :parent_id => "")))},  

                        {:title => "Pickup Wedding Souvenirs",
                        :due_date => @date.months_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "souvenirs, gifts",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                            @event.tasks.create(:title => "Confirm Wedding Souvenirs order",
                                :due_date => @date.months_ago(3),
                                :completed => false,
                                :redo => false,
                                :reminder => "",
                                :optional => false,
                                :note => "",
                                :tag_list => "souvenirs, gifts",
                                :importance => 2,
                                :rank => 1,
                                :event_id => @event.id,
                                :user_id => @user.id,
                                :parent =>
                                  @event.tasks.create(:title => "Decide on Wedding Souvenirs design",
                                      :due_date => @date.months_ago(3),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "",
                                      :tag_list => "souvenirs, gifts",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id => ""))},  

                        {:title => "Confirm date and time with Music Band",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "music",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                            @event.tasks.create(:title => "Book a Music Band for the wedding day",
                                :due_date => @date.months_ago(3),
                                :completed => false,
                                :redo => false,
                                :reminder => "",
                                :optional => false,
                                :note => "",
                                :tag_list => "music",
                                :importance => 2,
                                :rank => 1,
                                :event_id => @event.id,
                                :user_id => @user.id,
                                :parent =>
                                  @event.tasks.create(:title => "Decide on type of music to be played on wedding day",
                                      :due_date => @date.months_ago(3),
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => false,
                                      :note => "",
                                      :tag_list => "music",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id => ""))}, 

                        {:title => "Confirm the event agenda with Master of Ceremony",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Ask a person to be the Master of Ceremony for the event",
                              :due_date => @date.months_ago(1),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id => "")}, 
                        {:title => "Confirm date and time with the receptionists",
                        :due_date => @date.weeks_ago(2),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "music",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Ask people to be event receptionists",
                              :due_date => @date.months_ago(1),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "",
                              :tag_list => "music",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id => "")}, 
                        {:title => "Create the event day Agenda",
                        :due_date => @date.months_ago(1),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "wedding planner",
                        :importance => 2,
                        :rank => 0,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent_id => ""}, 

                        {:title => "Ask a person to see through the agenda on wedding day",
                        :due_date => @date.months_ago(1),
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "",
                        :tag_list => "wedding planner",
                        :importance => 2,
                        :rank => 0,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent_id => ""}])
            

    
        return render :json=> {:success => true, :message => "default tasks created!"}

      else
        return render :json=> {:success => false, :message => "smthing wrong!"}
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

