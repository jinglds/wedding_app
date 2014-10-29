module Api
  class ShopsController < Api::BaseController
    # before_filter :authenticate_user!
    # acts_as_token_authenticatable
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

  end
end

