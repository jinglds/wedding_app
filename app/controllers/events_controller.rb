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
    @tasks = @event.tasks

    # @days = @event.date + @event.time
  end

  def destroy
    @event.destroy
    redirect_to root_url
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
