module Api
  class FavoriteShopsController < Api::BaseController
    before_action :set_shop, only: [:create]
    before_action :set_resource, only: [:destroy]
    # load_and_authorize_resource
    before_filter :verify_token, only: [:create, :destroy]

    def destroy
      if (Favorite.where(favorited_id: @shop.id, user_id: app_user.id).first.destroy)
        return render :json=> {:success => true, :message => "shop removed favorite"}
      else
        return render :json=> {:success => false, :message => "shop not removed to favorite"}
      end
    end

    def create
      if (Favorite.create(favorited: @shop, user: app_user))
        return render :json=> {:success => true, :message => "shop added to favorite"}
      else
        return render :json=> {:success => false, :message => "shop not added to favorite"}
      end
    end
    
    
    
    private

    def verify_token
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
        token = request.headers['X-User-Token'].to_s
        
        # token_user = User.find_by_authentication_token(token)
          return render :json=> {:error=>"Error with your email"} unless user
        
          return render :json=> {:error=>"Error with your authentication token"} unless (user.authentication_token==token)
        
    end

    def set_shop
      @shop = Shop.find(params[:shop_id])
    end

    def set_resource(resource = nil)
      @shop = Shop.find(params[:id])
    end

    def app_user
      email =request.headers['X-User-Email'].to_s
      user = User.find_by_email(email)
    end

  end
end
