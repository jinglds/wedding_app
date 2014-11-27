module Api
  class ChecklistsController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
    before_filter :correct_user, only: [:destroy, :update, :pay, :unpay]

    def complete
      @checklist = Checklist.find(params[:checklist_id])
      
      if (@checklist.update_attributes(:completed => true))
    
        return render :json=> {:success => true, :message => "checklist completed successfully"}
      else
        return render :json=> {:success => false, :message => "checklist completed unsuccessfully"}
      end
    end

    def decomplete
      @checklist = Checklist.find(params[:checklist_id])

      if (@checklist.update_attributes(:completed => false) )
        return render :json=> {:success => true, :message => "checklist decompleted  successfully"}
      else
        return render :json=> {:success => false, :message => "checklist decompleted  unsuccessfully"}
      end
      
    end
   def create
      @event = Event.find(params[:event_id])

      
      @checklist = @event.checklists.build(checklist_params)
      @checklist.event = @event
      @checklist.user = app_user
      if @checklist.save
          return render :json=> {:success => true, :checklist => @checklist}
        else
          return render :json=> {:success => false, :message => "checklist not created"}
        end
      end

      def index
        @event = Event.find(params[:event_id])
        @checklists = @event.checklists
      end

      def show
        @event = Event.find(params[:event_id])
        @checklist = Checklist.find(params[:id])
        @vendor = @checklist.vendor
      end

      def update
        @checklist = Checklist.find(params[:id])
        if @checklist.update_attributes(checklist_params)
          return render :json=> {:success => true, :checklist => @checklist}
        else
          return render :json=> {:success => false, :message => "error updating checklist"}
        end
      end

      def destroy
        @checklist = Checklist.find(params[:id])
        if @checklist.destroy
           return render :json=> {:success => true, :message => "checklist deleted"}
        else
          return render :json=> {:success => false, :message => "error deleting checklist"}
        end
      end

      private

      def checklist_params
        params.require(:checklist).permit(:title,
                                    :event_id,
                                    :completed,
                                    :time_range,
                                    :task_id,
                                    :user_id)


      end


      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @checklist = app_user.checklists.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the checklist owner"} if @checklist.nil?
      end

    end
  end
