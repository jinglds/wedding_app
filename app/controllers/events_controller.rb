class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_filter :set_date, only: [:create, :update]

  def my_tasks
    @event = Event.find(params[:event_id])
    if params[:filter] =="week"
      @tasks= @event.tasks.this_week.order(due_date: :asc)
    elsif params[:filter] == "month"
      @tasks= @event.tasks.this_month.order(due_date: :desc)
    else
      @tasks = @event.tasks
    end

    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
    
  end

  def new
    @event = Event.new
    
  end
  
  def create
    
  	@event = current_user.events.build(event_params)
    # @event.date = @event.date.change(hour: @event.time.hour, min: @event.time.min, sec: @event.time.sec)
  	if @event.save
  		flash[:success] = "Event created!"
  		redirect_to @event
  	else
  		render 'new'
  	end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to @event, notice: "Successfully updated event"
    else
      render :edit
    end
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @expenses = @event.expenses
    @total = @event.expenses.sum(:amount)
    @tasks = @event.tasks.roots

    @completed = @event.tasks.done
    # @now = @event.tasks.now
    @now = @event.tasks.this_week
    # @days = @event.date + @event.time
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def destroy
    @event.destroy
    redirect_to root_url
  end

  def create_default_tasks
    @event = Event.find(params[:event_id])
    @date = @event.date
    @user = current_user
    @event.tasks.create([{:title => "Choose a theme for the Wedding",
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
            

      # @task.each.event = @event
      # @task.each.user = current_user
    # if @task.save
         flash[:success] = "Task created!"
         redirect_to @event
        
    #   else
    #     flash[:success] = "Error!"
    #       render @event
    #   end
    
  end

  private
  def event_params
  	params.require(:event).permit(:event_type,
  								:name,
  								:date,
                  :time,
  								:budget,
  								:bride_name,
  								:groom_name)
  end

  def correct_user
        @event = current_user.events.find_by(id: params[:id])
        redirect_to root_url if @event.nil?
  end

  def set_date
    @date = DateTime.parse(params[:event][:date])
    @time = DateTime.parse(params[:event][:time])
    @date = @date.change(hour: @time.hour, min: @time.min, sec: @time.sec)
    params[:event][:date] =@date
  end
end
