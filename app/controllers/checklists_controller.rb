class ChecklistsController < ApplicationController

	def index
    @event = Event.find(params[:event_id])
    @checklists = @event.checklists
    @tasks = @event.tasks

    respond_to do |format|
      format.html 
      format.js
    end
  end


	def create
      @event = Event.find(params[:event_id])

      @checklist = @event.checklists.build(checklist_params)
      @checklist.event = @event
      @checklist.user = current_user
      # @checklist_items = @event.checklists

        # respond_to do |format|
      if @checklist.save
         flash[:success] = "Checklist created!"
         redirect_to @event
        
      else
        flash[:success] = "Error!"
          render 'new'
      end
  end

  def destroy
      @event= Event.find(params[:event_id])
      @checklist = @event.checklists.find(params[:id])
      @checklist.destroy

      flash[:success] = "Checklist deleted!"
         redirect_to @event
  end

  def edit
    @checklist = Checklist.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @checklist = Checklist.find(params[:id])

    if @checklist.update_attributes(checklist_params)
      redirect_to event_checklist_path(@checklist.event, @checklist), notice: "Successfully updated event"
    else
      render :edit
    end
  end


	def complete
	    @event = Event.find(params[:event_id])
	    @checklist = Checklist.find(params[:checklist_id])
	    
	    # @checklist.toggle!(:completed)
	    if @checklist.update_attributes(:completed => true) 
	    	redirect_to event_checklists_path
	    end
	end
	def decomplete
	    @event = Event.find(params[:event_id])
	    @checklist = Checklist.find(params[:checklist_id])
	    
	    # @checklist.toggle!(:completed)
	    if @checklist.update_attributes(:completed => false) 
	    	redirect_to event_checklists_path
	    end
	end


	def checklist_params
        params.require(:checklist).permit(:title,
                                    :event_id,
                                    :completed,
                                    :time_range,
                                    :task_id,
                                    :user_id)


      end
end
