class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_filter :set_date, only: [:create, :update]


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
    @now = @event.tasks.now
    # @days = @event.date + @event.time
  end

  def destroy
    @event.destroy
    redirect_to root_url
  end

  def create_default_tasks
    @event = Event.find(params[:event_id])
    @date = @event.date
    @user = current_user
    @event.tasks.create([{:title => "Confirm number of guest",
                        :due_date => "11/11/14",
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
                        :parent =>
                          @event.tasks.create(:title => "Create a Guest List",
                              :due_date => "11/11/14",
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "tips: ",
                              :tag_list => "guest",
                              :importance => 2,
                              :rank => 0,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent_id =>"")},

                        {:title => "Confirm event date and number of guests with Wedding Venue",
                        :due_date => "11/11/14",
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "tips: ",
                        :tag_list => "venue",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Book Wedding Venue",
                              :due_date => "11/11/14",
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "tips: ",
                              :tag_list => "venue",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose Wedding Venues",
                                      :due_date => "11/11/14",
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
                        :due_date => "",
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "tips: ",
                        :tag_list => "caterer, food",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Choose Menus with Caterer",
                              :due_date => "",
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "tips: ",
                              :tag_list => "caterer, food",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Choose wedding day Caterer",
                                      :due_date => "",
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
                        {:title => "Setup Wedding Cake at the Venue",
                        :due_date => "",
                        :completed => false,
                        :redo => false,
                        :reminder => "",
                        :optional => false,
                        :note => "tips: ",
                        :tag_list => "wedding cake, venue",
                        :importance => 2,
                        :rank => 1,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent =>
                          @event.tasks.create(:title => "Get Wedding Cake",
                              :due_date => "",
                              :completed => false,
                              :redo => false,
                              :reminder => "",
                              :optional => false,
                              :note => "tips: ",
                              :tag_list => "wedding cake",
                              :importance => 2,
                              :rank => 1,
                              :event_id => @event.id,
                              :user_id => @user.id,
                              :parent =>
                                  @event.tasks.create(:title => "Confirm on Wedding Cake order",
                                      :due_date => "",
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
                                            :due_date => "",
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
                                            :parent_id =>"")))},                      
                        {:title => "boboboobbo",
                        :due_date => "11/11/14",
                        :completed => "",
                        :redo => "",
                        :reminder => "",
                        :optional => "",
                        :note => "do this first!",
                        :tag_list => "guest",
                        :importance => 2,
                        :rank => 0,
                        :event_id => @event.id,
                        :user_id => @user.id,
                        :parent_id =>""}])
            

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
