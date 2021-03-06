class EventsController < ApplicationController
  before_filter :authenticate_user!
  # before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]
  after_filter :create_checklist, only: [:create]
  before_action :collaborator, only: [:update, :edit, :clear_tasks, :create_default_tasks, :show]
      
  # before_filter :set_date, only: [:create, :update]

  
  def js_tasks
    @events = current_user.events.all
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def invitation_card
      @event = Event.find(params[:event_id])
      @event.update_attributes(:invitation_card=> params[:invitation_card]) 
      redirect_to event_guests_invitation_path(@event)
  
  end

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
    params[:event][:date] = Chronic.parse(params[:event][:date])
  	@event = current_user.events.build(event_params)
    if @event.save
      :create_checklist
  		flash[:success] = "Event created!"

  		redirect_to @event
  	else
  		render 'new'
  	end
  end

  def create_checklist
      @user = current_user
      @event.checklists.create([{:title => "Create a Guest List",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose a theme for the Wedding",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose Attire",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},


                        {:title => "Choose Wedding Ring",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id}, 

                        {:title => "Decide on the invitation card",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose wedding souvenirs",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose & Book Makeup Artist and Hairstylist",
                        :time_range => 180,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},



                        # 2months before

                        {:title => "Confirm number of guest",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Book Wedding Venue",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose Menus",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Confirm Photographers and Cinematographer",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Confirm Makeup Artist and Hairstylist",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},


                        {:title => "Print Invitation Card",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},


                        {:title => "Order wedding souvenirs",
                        :time_range => 60,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},



                        # 1 week before

                        {:title => "Confirm event date and number of guests with Wedding Venue",
                        :time_range => 7,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Confirm Menu and number of Guests with Caterer",
                        :time_range => 7,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Choose people to be receptionist",
                        :time_range => 7,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},

                        {:title => "Create an agenda for the wedding day",
                        :time_range => 7,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id},


                        {:title => "Setup Wedding Cake",
                        :time_range => 7,
                        :completed => false,
                        :event_id => @event.id,
                        :user_id => @user.id}
                        ])

                        
  end


  def new_cont
    @shops = Shop.all
    @new = Event.new
    @user = current_user
    @event = Event.find(params[:event_id])
    respond_to do |format|
      format.html 
      format.js
    end
  end


  def edit
    @event = Event.find(params[:id])
  end

  def update
    
    params[:event][:date] = Chronic.parse(params[:event][:date])
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
    @guests = @event.guests
    @expenses = @event.expenses;
    @total = @event.expenses.sum(:amount)
    @tasks = @event.tasks
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    # @amount = @
    @completed = @event.tasks.done
    # @now = @event.tasks.now
    @now = @event.tasks.this_week
    @lates = @tasks.lates.not_done
    @today = @tasks.today(:date=>Time.zone.now).not_done
    @checklists = @event.checklists

    unless @checklists.nil?
      if @checklists.done.count==0
        @progress = 0
      else
        @progress = ((@checklists.done.count.to_f/@checklists.count.to_f)*100).to_i
      end
    end


    @ex_percentage = ((@expenses.sum(:amount) / @event.budget) * 100).to_i
    
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def destroy
    @event.destroy
    redirect_to root_url
  end

  def clear_tasks
    @event = Event.find(params[:event_id])
    Task.where(:event_id=>@event.id, :optional =>true).destroy_all
    redirect_to event_tasks_path(@event)
    
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
                        :optional => true,
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
                        :optional => true,
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
                              :optional => true,
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
                        :optional => true,
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
                              :optional => true,
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
                                      :optional => true,
                                      :note => "tips: The budget and the number of guests will be factors in choosing the wedding venue.",
                                      :tag_list => "venue",
                                      :importance => 2,
                                      :rank => 0,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent_id =>""))},
                        {:title => "Confirm Menu and number of Guests with Caterer",
                        :due_date => @date.weeks_ago(2) + 3.days,
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
                        :note => "",
                        :tag_list => "caterer, food",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Choose Menus with Caterer",
                              :due_date => @date.months_ago(2) + 3.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "caterer, food",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose wedding day Caterer",
                                      :due_date => @date.months_ago(6) + 3.days,
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => true,
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
                              :due_date => @date.months_ago(2)+6.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "wedding cake",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                @event.tasks.create(:title => "Decide on & Order Wedding Cake",
                                    :due_date => @date.months_ago(6)+6.days,
                                    :completed => false,
                                    :redo => false,
                                    :reminder => "",
                                    :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "attire",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Final Attire fitting and makeup",
                              :due_date => @date.weeks_ago(3),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "attire",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                @event.tasks.create(:title => "Do fitting for attire",
                                    :due_date => @date.months_ago(3),
                                    :completed => false,
                                    :redo => true,
                                    :reminder => "",
                                    :optional => true,
                                    :note => "",
                                    :tag_list => "attire",
                                    :importance => 2,
                                    :rank => 1,
                                    :event_id => @event.id,
                                    :user_id => @user.id,
                                    :parent =>
                                        @event.tasks.create(:title => "Choose Wedding Attire for bride, grooms, and attendees",
                                            :due_date => @date.months_ago(6)+9.days,
                                            :completed => false,
                                            :redo => false,
                                            :reminder => "",
                                            :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "rings",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Choose Wedding/Engagement Rings",
                              :due_date => @date.months_ago(6)+12.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "makeup, hair",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Makeup Artist and Hairstylist",
                              :due_date => @date.months_ago(3),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "makeup, hair",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Makeup Artist and Hairstylist",
                                      :due_date => @date.months_ago(6)+12.days,
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "photo, photograpny, cinematography",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Photographers and Cinematographer",
                              :due_date => @date.months_ago(3),
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "photo, photograpny, cinematography",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Photographers and Cinematographer",
                                      :due_date => @date.months_ago(6)+15.days,
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => true,
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
                              :due_date => @date.months_ago(6)+20.days,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "invitation cards, cards",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Print out / Pickup Invitation Cards",
                              :due_date => @date.months_ago(3)+14.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
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
                                      :optional => true,
                                      :note => "tips: You can choose to design the invitation card on their own or customize from the catalog from the card shop.",
                                      :tag_list => "invitation cards, cards",
                                      :importance => 2,
                                      :rank => 1,
                                      :event_id => @event.id,
                                      :user_id => @user.id,
                                      :parent =>
                                        @event.tasks.create(:title => "Decide on Invitation Cards design",
                                            :due_date => @date.months_ago(4),
                                            :completed => false,
                                            :redo => false,
                                            :reminder => "",
                                            :optional => true,
                                            :note => "",
                                            :tag_list => "invitation cards, cards",
                                            :importance => 2,
                                            :rank => 0,
                                            :event_id => @event.id,
                                            :user_id => @user.id,
                                            :parent_id => "")))},  

                        {:title => "Pickup Wedding Souvenirs",
                        :due_date => @date.months_ago(3)+7.days,
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
                        :note => "",
                        :tag_list => "souvenirs, gifts",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                            @event.tasks.create(:title => "Confirm Wedding Souvenirs order",
                                :due_date => @date.months_ago(4)+14.days,
                                :completed => false,
                                :redo => false,
                                :reminder => "",
                                :optional => true,
                                :note => "",
                                :tag_list => "souvenirs, gifts",
                                :importance => 2,
                                :rank => 1,
                                :event_id => @event.id,
                                :user_id => @user.id,
                                :parent =>
                                  @event.tasks.create(:title => "Decide on Wedding Souvenirs design",
                                      :due_date => @date.months_ago(4)+7,
                                      :completed => false,
                                      :redo => false,
                                      :reminder => "",
                                      :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "music",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                            @event.tasks.create(:title => "Book a Music Band for the wedding day",
                                :due_date => @date.months_ago(3)+7.days,
                                :completed => false,
                                :redo => false,
                                :reminder => "",
                                :optional => true,
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
                                      :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Ask a person to be the Master of Ceremony for the event",
                              :due_date => @date.months_ago(2)+14.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
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
                        :optional => true,
                        :note => "",
                        :tag_list => "music",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Ask people to be event receptionists",
                              :due_date => @date.months_ago(2)+14.days,
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => true,
                              :note => "",
                              :tag_list => "music",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id => "")}, 
                        {:title => "Create the event day Agenda",
                        :due_date => @date.months_ago(2)+14.days,
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
                        :note => "",
                        :tag_list => "wedding planner",
                        :importance => 2,
                        :rank => 0,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent_id => ""}, 

                        {:title => "Ask a person to see through the agenda on wedding day",
                        :due_date => @date.months_ago(2)+14.days,
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => true,
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
         redirect_to event_tasks_path(@event)
        
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
                  # :time,
  								:budget,
  								:bride_name,
  								:groom_name,
                  :guest_amt,
                  :invitation_card)
  end

  def correct_user
        @event = current_user.events.find_by(id: params[:id] || params[:event_id])
        redirect_to root_url if @event.nil?
  end

  def collaborator
    @myevent = current_user.events.find_by(id: params[:id] || params[:event_id])
    @event = Event.find_by(:id=> Collaboration.where(:event_id=> (params[:id] || params[:event_id]), :user_id=>current_user.id, :accepted=>true))
    redirect_to root_url if (@event.nil? && @myevent.nil?)
  end

  def set_date
    unless (params[:event][:date]=="" && params[:event][:time]=="")
      if (params[:event][:time]=="")

        @date = DateTime.parse(params[:event][:date])
      elsif (params[:event][:date]=="")
        @time = DateTime.parse(params[:event][:time])
      else
        @date = DateTime.parse(params[:event][:date])
        @time = DateTime.parse(params[:event][:time])
        @date = @date.change(hour: @time.hour, min: @time.min, sec: @time.sec)
        params[:event][:date] =@date
      end

    end
  end
end
