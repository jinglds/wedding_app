module Api
  class ShopsController < Api::BaseController
    # before_filter :verify_authenticity_token
    # skip_before_filter :verify_authenticity_token
     load_and_authorize_resource
     before_filter :verify_token, only: [:index, :show]

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

    # def update
    #   @shop = Shop.find(params[:id])

    #   if @shop.update_attributes(shop_params)
    #     return render :json=> {:success => true, :message => "shop rated successfully"}
    #   else
    #     return render :json=> {:success => false, :message => "shop rated unsuccessfully"}
    #   end
    # end

    # def destroy
    #   @shop.destroy
    #   redirect_to root_url
    # end

    def rate
      @shop = Shop.find(params[:id])
      if (@shop.liked_by app_user, :vote_weight => (params[:rating][:weight]).to_s)
# respond_to format.js
        return render :json=> {:success => true, :message => "shop rated successfully"}
      else
        return render :json=> {:success => false, :message => "shop rated unsuccessfully"}
      end
    end



    def unrate
      @shop = Shop.find(params[:id])
      if (@shop.unliked_by app_user)
        return render :json=> {:success => true, :message => "shop unrated successfully"}
      else
        return render :json=> {:success => false, :message => "shop unrated unsuccessfully"}
      end

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

      def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
      end




  end
end

