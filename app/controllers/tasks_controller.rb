class TasksController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @event = Event.find(params[:event_id])
    @tasks = @event.tasks
    
  end

  def show
    @event = Event.find(params[:event_id])
    @task = Task.find(params[:id])
  end

 def create
      @event = Event.find(params[:event_id])
      @event_day = @event.date
      @task = @event.tasks.build(task_params)
      @task.event = @event
      @task.user = current_user
      @task_items = @event.tasks

        # respond_to do |format|
      if @task.save
         flash[:success] = "Task created!"
         redirect_to @event
        
      else
        flash[:success] = "Error!"
          render @event
      end
  end

  def new
      @event = Event.find(params[:event_id])
      @task = @event.tasks.new
      @task = Task.new
  end

  def destroy
      @event= Event.find(params[:event_id])
      @task = @event.tasks.find(params[:id])
      @task.destroy

      flash[:success] = "Task deleted!"
         redirect_to @event
  end

  def edit
    @task = Task.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(task_params)
      redirect_to event_task_path(@task.event, @task), notice: "Successfully updated event"
    else
      render :edit
    end
  end

  private
  def task_params
  	params.require(:task).permit(:amount,
  								:task_type,
  								:receiver,
  								:title,
  								:status,
                  :user_id)


  end

    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        redirect_to root_url if @task.nil?
  end
end
