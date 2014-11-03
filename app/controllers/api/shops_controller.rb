module Api
  class ShopsController < Api::BaseController
    # before_filter :verify_authenticity_token
     load_and_authorize_resource
     before_filter :verify_token, only: [:index, :show, :rate]

    def index
      @shops = Shop.all

    end

    def show
      @shop = Shop.find(params[:id])
      @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
      # @comment = Comment.new 
      @comments =  @shop.comment_feed
      # @photos = @shop.photos.all
    end

#     def rate
#       @shop = Shop.find(params[:id])
      
#       @shop.liked_by current_user, :vote_weight => params[:rating][:weight])
# # respond_to format.js
#       # return render :json=> {:message => "shop rated successfully"}
    
#     end


# # curl -i -H "Accept: application/json" -H "Content-type: application/json" -H "X-User-Email: jinpeko@gmail.com" -H "X-User-Token: d-zzPmoTtPS9GBYtxeoP" -X PUT http://localhost:3000/api/shops/205/rate -d '{"rating": {"weight": "3"}}' 



#     def unrate
#       @shop = Shop.find(params[:id])
#       @shop.unliked_by current_user
     

#     end

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

