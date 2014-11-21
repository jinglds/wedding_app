module Api
  class TasksController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
    before_filter :correct_user, only: [:destroy, :update, :pay, :unpay]

    def complete
      @task = Task.find(params[:task_id])
      
      if (@task.update_attributes(:completed => true, :rank => (@task.rank)) 
    )
        return render :json=> {:success => true, :message => "task completed successfully"}
      else
        return render :json=> {:success => false, :message => "task completed unsuccessfully"}
      end
    end

    def decomplete
      @task = Task.find(params[:task_id])

      if params[:cascade]=="true"
      @task.descendants.each do |c|
        c.update_attributes(:rank => 1, :completed => 'f')
      end
    # else
    #   @task.descendants.each do |c|
    #     c.update_attribute(:rank, 1)
    #   end
    end
      if (@task.update_attributes(:completed => false))
        return render :json=> {:success => true, :message => "task unpaid  successfully"}
      else
        return render :json=> {:success => false, :message => "task unpaid  unsuccessfully"}
      end
      
    end
   def create
      @event = Event.find(params[:event_id])

      if params[:task][:parent_id]!=""
        @parent = Task.find(params[:task][:parent_id])
        params[:task][:rank] = 1
      end

      @date = Chronic.parse(params[:task][:due_date])
      params[:task][:due_date] = @date
      
      @task = @event.tasks.build(task_params)
      @task.event = @event
      @task.user = app_user
      if @task.save
          return render :json=> {:success => true, :task => @task}
        else
          return render :json=> {:success => false, :message => "task not created"}
        end
      end

      def index
        @event = Event.find(params[:event_id])
        @tasks = @event.tasks
      end

      def show
        @event = Event.find(params[:event_id])
        @task = Task.find(params[:id])
        @vendor = @task.vendor
      end

      def update
        @task = Task.find(params[:id])
        if @task.update_attributes(task_params)
          return render :json=> {:success => true, :task => @task}
        else
          return render :json=> {:success => false, :message => "error updating task"}
        end
      end

      def destroy
        @task = Task.find(params[:id])
        if @task.destroy
           return render :json=> {:success => true, :message => "task deleted"}
        else
          return render :json=> {:success => false, :message => "error deleting task"}
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
                                    :rank,
                                    :vendor_id)


      end


      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @task = app_user.tasks.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the task owner"} if @task.nil?
      end

    end
  end
