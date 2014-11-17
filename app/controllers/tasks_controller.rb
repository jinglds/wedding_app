class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_action :correct_user,   only: :destroy

  def index
    @event = Event.find(params[:event_id])
    @tasks = @event.tasks
    @month_date = params[:month] ? Date.parse(params[:month]) : Date.today
    @week_date = params[:week] ? Date.parse(params[:week]) : Date.today
    @date = params[:day] ? Date.parse(params[:day]) : Date.today
    @week_dates = (@week_date.at_beginning_of_week..@week_date.at_end_of_week).map
    
    @today = @event.tasks.today(:date=>@date)
    @done = @event.tasks.done
    @now = @event.tasks.now

    # @today = params[:date] ? Task.today(param[:date]) : nil
    # @today_tasks = Task.where(:due_date => @date.beginning_of_day..@date.end_of_day)
   
  end
  def calendar
    @event = Event.find(params[:event_id])
    @tasks = @event.tasks
    @month_date = params[:month] ? Date.parse(params[:month]) : Date.today
    @week_date = params[:week] ? Date.parse(params[:week]) : Date.today
    @date = params[:day] ? Date.parse(params[:day]) : Date.today
    @week_dates = (@week_date.at_beginning_of_week..@week_date.at_end_of_week).map
    @today = @event.tasks.today(:date=>@date)
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
    
  
    
  end

  def show
    @event = Event.find(params[:event_id])
    @task = Task.find(params[:id])
    @child = @task.children 




  end

 def create
      @event = Event.find(params[:event_id])

      if params[:task][:parent_id]!=""
        @parent = Task.find(params[:task][:parent_id])
        params[:task][:rank] = 1
      end

      @date = Chronic.parse(params[:task][:due_date])
      # params[:task][:due_date] = Date.today
      params[:task][:due_date] = @date
      # @event_day = @event.date
      
      @task = @event.tasks.build(task_params)
      @task.event = @event
      @task.user = current_user
      # @task_items = @event.tasks

        # respond_to do |format|
      if @task.save
         flash[:success] = "Task created!"
         redirect_to @event
        
      else
        flash[:success] = "Error!"
          render 'new'
      end
  end

  def new
      @event = Event.find(params[:event_id])
      # @task = @event.tasks.new
      # @task = Task.new(:parent_id => params[:parent_id])

      @task = @event.tasks.new(:parent_id => params[:parent_id])
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



  def complete
    @event = Event.find(params[:event_id])
    @task = Task.find(params[:task_id])
    
    # @task.toggle!(:completed)
    @task.update_attributes(:completed => true, :rank => (@task.rank)) 
    # @task.descendants.each do |d|
    #   d.update_attribute(:rank, (d.rank - 1))
    # end
    @task.children.each do |c|
      c.update_attribute(:rank, 0)
    end

    @child = @task.children.first
    @done = @event.tasks.done
    @now = @event.tasks.now

    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end

  def decomplete
    @event = Event.find(params[:event_id])
    @task = Task.find(params[:task_id])
    

    @task.update_attribute(:completed,false)

    if params[:cascade]=="true"
      @task.descendants.each do |c|
        c.update_attributes(:rank => 1, :completed => 'f')
      end
    # else
    #   @task.descendants.each do |c|
    #     c.update_attribute(:rank, 1)
    #   end
    end
    # @task.toggle!(:completed)
    # @task.descendants.each do |d|
    #   d.update_attribute(:rank, (d.rank + 1))
    # end
 @done = @event.tasks.done
    @now = @event.tasks.now

    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
    
  end




  private
  def task_params
  	params.require(:task).permit(:title,
                                :due_date,
                                :completed,
                                :redo,
                                :reminder,
                                :optional,
                                :note,
                                :tag_list,
                                :parent_id,
                                :importance,
                                :rank)


  end

    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        redirect_to root_url if @task.nil?
  end
end
