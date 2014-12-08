module Api
  class ShopsController < Api::BaseController
    # before_filter :verify_authenticity_token
    skip_before_filter :verify_authenticity_token, only: [:create]
     # load_and_authorize_resource
     before_filter :verify_token, only: [:index, :show, :create]
     before_filter :correct_user, only: [:destroy, :update]

     def tags
      @styles = Shop.style_counts
      @categories = Shop.category_counts
     end

    def create


      if params[:shop][:attachment]["file"]
           attachment_params = params[:shop][:attachment]
           #create a new tempfile named fileupload
           tempfile = Tempfile.new("fileupload")
           tempfile.binmode
           #get the file and decode it with base64 then write it to the tempfile
           if tempfile.write(Base64.decode64(attachment_params["file"]))
            puts 'decoded!'
          end
           #create a new uploaded file
           uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => "shop_attachment" , :original_filename => "shop_attachment") 
     
           #replace picture_path with the new uploaded file
           params[:shop][:attachment] =  uploaded_file
     
      end
  
          


      # @shop = app_user.shops.build(shop_params)


      if app_user.shops.create!(shop_params)
        return render :json=> {:success => true, :shop => @shop}
        puts 'created'
        tempfile.delete
      else
        return render :json=> {:success => false, :message => "shop not created"}
        puts 'not created'
        tempfile.delete
      end
    end

    def index
      # @shops = Shop.all
      # @related = Shop.tagged_with(@shop.style_list, :any => true, :order_by_matching_tag_count => true).limit(5)
      if params[:tags].nil?
        return render :json=> {:message => "No tag params"} 
      else
        @categories = params[:tags][:categories]
        @styles = params[:tags][:styles]
        if @categories=="" && @styles ==""
          @shops = Shop.all
        elsif @categories!="" && @styles ==""
          @shops = Shop.tagged_with([@categories], :on => :categories, :any => true)
        elsif @categories=="" && @styles !=""
          @shops = Shop.tagged_with([@styles], :on => :styles, :any => true)
        else
          @shops = Shop.tagged_with([@categories], :on => :categories, :any => true).tagged_with([@styles], :on => :styles, :any => true)
        end
        return render :json=> {:message => "No match found"} if @shops.blank?
      end
    end

    def get_shop
      if params[:tags].nil?
        return render :json=> {:message => "No tag params"} 
      else
        @categories = params[:tags][:categories]
        @styles = params[:tags][:styles]
        if @categories=="" && @styles ==""
          @shops = Shop.all
        elsif @categories!="" && @styles ==""
          @shops = Shop.tagged_with([@categories], :on => :categories, :any => true)
        elsif @categories=="" && @styles !=""
          @shops = Shop.tagged_with([@styles], :on => :styles, :any => true)
        else
          @shops = Shop.tagged_with([@categories], :on => :categories, :any => true).tagged_with([@styles], :on => :styles, :any => true)
        end
        @shops= @shops.search(params[:tags][:name_query]) unless params[:tags][:name_query]==""
      
        return render :json=> {:message => "No match found"} if @shops.blank?
      end
    end

    def show
      @shop = Shop.find(params[:id])
      @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
      @favorite = app_user.favorites.find_by(favorited_id: @shop.id)
      @comments =  @shop.comment_feed
      # @photos = @shop.photos.all
    end

    def update
      if @shop.update_attributes(shop_params)
        return render :json=> {:success => true, :shop => @shop}
      else
        return render :json=> {:success => false, :message => "error updating shop"}
      end
    end

    def destroy
      @shop = Shop.find(params[:id])
      if @shop.destroy
         return render :json=> {:success => true, :message => "shop deleted"}
      else
        return render :json=> {:success => false, :message => "error deleting shop"}
      end
    end

    def rate
      @shop = Shop.find(params[:id])
      if (@shop.liked_by app_user, :vote_weight => (params[:rating][:weight]).to_s)
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
        params.require(:shop).permit(:name,
                  :description,
                  :phone,
                  :address,
                  :details,
                  :email,
                  :website,
                  :price_range,
                  :category_list,
                  :style_list,
                  :attachment)

      end

      def query_params
        # this assumes that an album belongs to an artist and has an :artist_id
        # allowing us to filter by this
        params.permit(:category_list, :style_list)
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
        @shop = app_user.shops.find_by(id: params[:id])
        return render :json=> {:error=>"You are not the shop owner"} if @shop.nil?
      end



  end
end

