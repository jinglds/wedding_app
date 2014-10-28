class ExpensesController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


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
         redirect_to @expense
  end

  private
  def expense_params
  	params.require(:expense).permit(:amount,
  								:expense_type,
  								:receiver,
  								:title,
  								:status)


  end

    def correct_user
        @expense = current_user.expenses.find_by(id: params[:id])
        redirect_to root_url if @expense.nil?
  end
end
