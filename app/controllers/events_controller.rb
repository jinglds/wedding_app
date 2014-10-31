class EventsController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


  def new
    @event = Event.new
  end
  
  def create
  	@event = current_user.events.build(event_params)
  	if @event.save
  		flash[:success] = "Event created!"
  		redirect_to root_url
  	else
  		render'static_pages/home'
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
end
