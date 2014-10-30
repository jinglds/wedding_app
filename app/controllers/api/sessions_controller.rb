module Api
  class SessionsController < Devise::SessionsController
    skip_before_filter :verify_authenticity_token
    skip_before_filter :verify_signed_out_user
    acts_as_token_authentication_handler_for User
    # prepend_before_filter :verify_signed_out_user, only: :destroy
  #   before_filter :authenticate_user!, :except => [:create, :destroy]
  #   before_filter :ensure_params_exist
    # respond_to :json
  #   acts_as_token_authentication_handler_for User

# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb

  # POST /resource/sign_in
  # Resets the authentication token each time! Won't allow you to login on two devices
  # at the same time (so does logout).
  # def create
  #  self.resource = warden.authenticate!(auth_options)
  #  sign_in(resource_name, resource)
 
  #  current_user.update authentication_token: nil
 
  #  respond_to do |format|
  #    format.json {
  #      render :json => {
  #        :user => current_user,
  #        :status => :ok,
  #        :authentication_token => current_user.authentication_token
  #      }
  #    }
  #  end
  # end

  # DELETE /resource/sign_out
  # def destroy
 
  #  respond_to do |format|
  #    format.json {
  #      if current_user
  #        current_user.update authentication_token: nil
  #        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
  #        render :json => {}.to_json, :status => :ok
  #      else
  #        render :json => {}.to_json, :status => :unprocessable_entity
  #      end
       

  #    }
  #  end
  # end






   
    def create
      resource = User.find_for_database_authentication(:email => params[:user_login][:email])
      return invalid_login_attempt unless resource
   
      if resource.valid_password?(params[:user_login][:password])
        sign_in(:user, resource)
        resource.ensure_authentication_token!
        # if resource.authentication_token.blank?
        #   resource.authentication_token = generate_authentication_token
        # end
        render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
        return
      end
      invalid_login_attempt
    end
   
    def destroy
      resource = User.find_for_database_authentication(:email => params[:session][:email])
      token =  params[:session][:token]
      if (resource.authentication_token==token)
        resource.update authentication_token: nil
        resource.save
        render :json=> {:success=>true, :message=>"logout successfully"}
      else
        render :json=> {:success=>false, :message=>"Error with you authentication header"}
      end

    end

  #   # DELETE /resource/sign_out
  # # def destroy
 
  # #  respond_to do |format|
  # #    format.json {
  # #      if current_user
  # #        current_user.update authentication_token: nil
  # #        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
  # #        render :json => {}.to_json, :status => :ok
  # #      else
  # #        render :json => {}.to_json, :status => :unprocessable_entity
  # #      end
       

  # #    }
  # #  end
  # # end

  # # def destroy
  # #   # Fetch params
  # #   user = User.find_by(authentication_token: params[:user_token])
 
  # #   if user.nil?
  # #     render status: 404, json: { message: 'Invalid token.' }
  # #   else
  # #     user.authentication_token = nil
  # #     user.save!
  # #     render status: 204, json: nil
  # #   end
  # # end

   
    protected
    def ensure_params_exist
      return unless params[:user_login].blank?
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end
   
    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
  end
end