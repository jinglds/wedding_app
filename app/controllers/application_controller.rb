class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # acts_as_token_authentication_handler_for User
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json, :html

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/signin" &&
        request.path != "/users/sign_in" &&
        request.path != "/signup" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/signout" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname,  :email, 
                   :address, :phone, :email, 
                    :password, :password_confirmation, :approval) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end

      rescue_from CanCan::AccessDenied do |exception|  
        respond_to do |format|  
          format.json { render :json=> exception.to_json, :status => :forbidden }  
        end  
      end 

end
