class ExpensesController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy, :update, :pay, :unpay]

  def pay
    @event = Event.find(params[:event_id])
    @expense = Expense.find(params[:expense_id])
    @expense.update_attributes(:paid => true) 
    if params[:sort].nil?
      @expenses = @event.expenses.order(:paid)
    else
      @expenses = @event.expenses.order(params[:sort])
    end
    @total = @event.expenses.sum(:amount)
    @ex = @event.expenses.group(:expense_type).sum(:amount)
    
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end

  def unpay 
    @event = Event.find(params[:event_id])
    @expense = Expense.find(params[:expense_id])
    if params[:sort].nil?
      @expenses = @event.expenses.order(:paid)
    else
      @expenses = @event.expenses.order(params[:sort])
    end
    @total = @event.expenses.sum(:amount)
    @ex = @event.expenses.group(:expense_type).sum(:amount)
    
    @expense.update_attributes(:paid => false)
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end 
    
  end

  def index
    @event = Event.find(params[:event_id])
    if params[:sort].nil?
      @expenses = @event.expenses.order(:paid)
    else
      @expenses = @event.expenses.order(params[:sort])
    end
    @sort = params[:sort]
    @expense = Expense.new
    @ex = @event.expenses.group(:expense_type).sum(:amount)
    @expense_chart = {}
    @expense_chart["Used"]= @expenses.sum(:amount)
    if @expenses.sum(:amount) >= @event.budget
      @expense_chart["Current Balance"]=0
    else
      @expense_chart["Current Balance"]=@event.budget - @expenses.sum(:amount)
    end
    @total = @event.expenses.sum(:amount)
    # @x =@event.budget
    # @@x = @x
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
         redirect_to event_expenses_path(@event)
        
      else
        flash[:success] = "Error!"
          render event_expenses_path(@event)
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
         redirect_to event_expenses_path(@event)
  end

  def edit
    @expense = Expense.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def update
    @expense = Expense.find(params[:id])
    @event = Event.find(params[:event_id])
    if @expense.update_attributes(expense_params)
      flash[:success] = "Successfully updated expense"
      redirect_to event_expenses_path(@event)
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
                  :user_id,
                  :paid)


  end

    def correct_user
        @expense = current_user.expenses.find_by(id: params[:expense_id] || params[:id])
        redirect_to root_url if @expense.nil?
    end
end
