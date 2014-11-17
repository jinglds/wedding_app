class ExpensesController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @event = Event.find(params[:event_id])
    @expenses = @event.expenses

    @ex = @event.expenses.group(:expense_type).sum(:amount)
    @expense_chart = {}
    @expense_chart["Used"]= @expenses.sum(:amount)
    @expense_chart["Current Balance"]=@event.budget - @expenses.sum(:amount)
    
    
  end

  def show
    @event = Event.find(params[:event_id])
    @expense = Expense.find(params[:id])
  end

 def create
      @event = Event.find(params[:event_id])
      @expense = @event.expenses.build(expense_params)
      @expense.event = @event
      @expense.user = current_user
      @expense_items = @event.expenses

        # respond_to do |format|
      if @expense.save
         flash[:success] = "Expense created!"
         redirect_to @event
        
      else
        flash[:success] = "Error!"
          render @event
      end
  end

  def new
      @event = Event.find(params[:event_id])
      @expense = @event.expenses.new
      @expense = Expense.new
  end

  def destroy
      @event= Event.find(params[:event_id])
      @expense = @event.expenses.find(params[:id])
      @expense.destroy

      flash[:success] = "Expense deleted!"
         redirect_to @event
  end

  def edit
    @expense = Expense.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @expense = Expense.find(params[:id])

    if @expense.update_attributes(expense_params)
      redirect_to event_expense_path(@expense.event, @expense), notice: "Successfully updated event"
    else
      render :edit
    end
  end

  private
  def expense_params
  	params.require(:expense).permit(:amount,
  								:expense_type,
  								:receiver,
  								:title,
  								:status,
                  :user_id)


  end

    def correct_user
        @expense = current_user.expenses.find_by(id: params[:id])
        redirect_to root_url if @expense.nil?
  end
end
