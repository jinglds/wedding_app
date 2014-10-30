module Api
  class ShopsController < Api::BaseController
    before_filter :verify_authenticity_token
    # acts_as_token_authentication_handler_for Shop
    # acts_as_token_authenticatable
    # acts_as_token_authentication_handler_for User
     load_and_authorize_resource
     before_filter :verify_token

    def index
      @shops = Shop.all

    end

    def music
      @shops = Shop.all
    end



    private

      def shop_params
        params.require(:shop).permit(:name)
      end

      def query_params
        # this assumes that an album belongs to an artist and has an :artist_id
        # allowing us to filter by this
        params.permit(:user_id, :name)
      end

      def verify_token
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
        token = request.headers['X-User-Token'].to_s
        
        # token_user = User.find_by_authentication_token(token)
        
          return render :json=> {:error=>"Error with your authentication headers"} unless (user.authentication_token==token)
        
      end




  end
end

