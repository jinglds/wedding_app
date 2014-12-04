class ChecklistsController < ApplicationController
  before_filter :authenticate_user!
  before_action :correct_user,   only: [:destroy]
  before_action :collaborator, except: [:complete, :decomplete, :destroy]
	def index
    @event = Event.find(params[:event_id])
    @checklists = @event.checklists
    @tasks = @event.tasks
    @checklist= Checklist.new

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
         redirect_to event_checklists_path(@event)
        
      else
        flash[:danger] = "Error!"
          render event_checklists_path(@event)
      end
  end

  def destroy
      @event= Event.find(params[:event_id])
      @checklist = @event.checklists.find(params[:id])
      @checklist.destroy

      flash[:success] = "Checklist deleted!"
         redirect_to event_checklists_path
  end

  def edit
    @checklist = Checklist.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @checklist = Checklist.find(params[:id])

    if @checklist.update_attributes(checklist_params)
      redirect_to event_checklists_path, notice: "Successfully updated event"
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

  private
	def checklist_params
        params.require(:checklist).permit(:title,
                                    :event_id,
                                    :completed,
                                    :time_range,
                                    :task_id,
                                    :user_id)


      end

      def collaborator
    @myevent = current_user.events.find_by( params[:event_id])
    @event = Event.find(Collaboration.where(:event_id=> (params[:event_id]), :user_id=>current_user.id, :accepted=>true))
    redirect_to root_url if (@event.nil? && @myevent.nil?)
  end
  def correct_user
          @checklist = current_user.checklists.find_by(id: params[:id] || params[:checklist_id])
          redirect_to root_url if @checklist.nil?
  end
end
