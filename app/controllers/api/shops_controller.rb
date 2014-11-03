module Api
  class ShopsController < Api::BaseController
    before_filter :verify_authenticity_token
     load_and_authorize_resource
     before_filter :verify_token, only: [:index]

    def index
      @shops = Shop.all

    end

    def show
      @shop = Shop.find(params[:id])
      @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
      # @comment = Comment.new 
      @comments =  @shop.comment_feed
      @photos = @shop.photos.all
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
          return render :json=> {:error=>"Error with your email"} unless user
        
          return render :json=> {:error=>"Error with your authentication token"} unless (user.authentication_token==token)
        
      end




  end
end

