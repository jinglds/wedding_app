module Api
  class ExpensesController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
    before_filter :correct_user, only: [:destroy, :update, :pay, :unpay]

    def pay
      @expense = Expense.find(params[:expense_id])
      
      if (@expense.update_attributes(:paid => true))
        return render :json=> {:success => true, :message => "expense paid successfully"}
      else
        return render :json=> {:success => false, :message => "expense paid  unsuccessfully"}
      end
    end

    def unpay 
      @expense = Expense.find(params[:expense_id])
      if (@expense.update_attributes(:paid => false))
        return render :json=> {:success => true, :message => "expense unpaid  successfully"}
      else
        return render :json=> {:success => false, :message => "expense unpaid  unsuccessfully"}
      end
      
    end
   def create
      @event = Event.find(params[:event_id])
      @expense = @event.expenses.build(expense_params)
      @expense.event = @event
      @expense.user = app_user

        if  @expense.save
          return render :json=> {:success => true, :expense => @expense}
        else
          return render :json=> {:success => false, :message => "expense not created"}
        end
      end

      def index
        @event = Event.find(params[:event_id])
        @expenses = @event.expenses
        @total = @event.expenses.sum(:amount)
      end

      def show
        @event = Event.find(params[:event_id])
        @expense = Expense.find(params[:id])
        
      end

      def update
        @expense = Expense.find(params[:id])
        if @expense.update_attributes(expense_params)
          return render :json=> {:success => true, :expense => @expense}
        else
          return render :json=> {:success => false, :message => "error updating expense"}
        end
      end

      def destroy
        @expense = Expense.find(params[:id])
        if @expense.destroy
           return render :json=> {:success => true, :message => "expense deleted"}
        else
          return render :json=> {:success => false, :message => "error deleting expense"}
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


      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @expense = app_user.expenses.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the expense owner"} if @expense.nil?
      end

    end
  end
