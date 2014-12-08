module Api
  class CollaborationsController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
     before_filter :correct_user, only: [:destroy, :update]

    def create
      @user = User.find_by_email(params[:collaboration][:user_id])
    @event = Event.find(params[:collaboration][:event_id])

    if @user.nil?
      return render :json=> {:success => false, :message => "No user with that email"}
        else
          @col = Collaboration.where(:user_id=>@user.id, :event_id=>@event.id).first
          if @col.nil?
            if @user ==current_user
            return render :json=> {:success => false, :message => "You are the owner of event"}
          else
            params[:collaboration][:user_id] = @user.id
              if Collaboration.create!(collaboration_params)
                return render :json=> {:success => true, :collaboration => @collaboration}
              
            else
                return render :json=> {:success => false, :message => "error creating collaboration"}
              end
           end
        else
          return render :json=> {:success => false, :message => "Request already sent to that email"}
        end
      end
    end

    def index
      @collaborations = app_user.collaborations
    
    end


    def show
      @collaboration = Collaboration.find(params[:id])
    end

    def update
      if @collaboration.update_attributes(collaboration_params)
        return render :json=> {:success => true, :collaboration => @collaboration}
      else
        return render :json=> {:success => false, :message => "error updating collaboration"}
      end
    end

    def destroy
      @collaboration = Collaboration.find(params[:id])
      if @collaboration.destroy
         return render :json=> {:success => true, :message => "collaboration deleted"}
      else
        return render :json=> {:success => false, :message => "error deleting collaboration"}
      end
    end

    def remove
      @collaboration = Collaboration.where(:user_id=>params[:collaboration][:user_id], :event_id=> params[:collaboration][:event_id]).first
      
      if @collaboration.nil?
        return render :json=> {:success => false, :message => "no collaboration with given user_id and event_id"}
      else
          if @collaboration.destroy
             return render :json=> {:success => true, :message => "collaboration deleted"}
          else
            return render :json=> {:success => false, :message => "error deleting collaboration"}
          end
      end

    end

    def accept
      @collaboration = Collaboration.where(:user_id=>app_user.id, :event_id=> params[:collaboration][:event_id]).first
      
      @collaboration.update_attributes(:accepted => true) 
      return render :json=> {:success => true, :message => "collaboration accepted"}
    end

    private

      def collaboration_params
        params.require(:collaboration).permit(:user_id,
                                :event_id)

      end


      def verify_token
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
        token = request.headers['X-User-Token'].to_s
        
        # token_user = User.find_by_authentication_token(token)
          return render :json=> {:error=>"Error with your email"} unless user
        
          return render :json=> {:error=>"Error with your authentication token"} unless (user.authentication_token==token)
        
      end

      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end

      def correct_user
        @collaboration = app_user.collaborations.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the collaboration owner"} if @collaboration.nil?
      end



  end
end

