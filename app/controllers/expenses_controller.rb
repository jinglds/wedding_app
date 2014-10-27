class ExpensesController < ApplicationController
  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


  def new
    @expense = Expense.new
  end
  
  def create
  	@expense = current_user.expenses.build(expense_params)
  	if @expense.save
  		flash[:success] = "Expense created!"
  		redirect_to root_url
  	else
  		render'static_pages/home'
  	end
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])

    if @expense.update_attributes(expense_params)
      redirect_to @expense, notice: "Successfully updated expense"
    else
      render :edit
    end
  end

  def show
    @user = current_user
    @expense = Expense.find(params[:id])
  end

  def destroy
    @expense.destroy
    redirect_to root_url
  end

  private
  def expense_params
  	params.require(:expense).permit(:expense_type,
  								:name,
  								:date,
  								:time,
  								:budget,
  								:bride_name,
  								:groom_name)
  end

    def correct_user
        @expense = current_user.expenses.find_by(id: params[:id])
        redirect_to root_url if @expense.nil?
  end
end
