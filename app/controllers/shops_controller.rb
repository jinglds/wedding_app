class ShopsController < ApplicationController
  before_filter :store_location, only: [:create, :destroy, :index, :show, :edit]
  before_filter :authenticate_user!
  before_action :correct_user,   only: [:destroy, :edit]
  before_action :client_user, only: [:new, :create, :destroy]
  # before_filter :set_search, only: :index


  def category
    if params[:category]==""
      @shops = Shop.all
    else
      @shops = Shop.tagged_with(params[:category])
    end
    respond_to do |format|
      format.html 
      format.js
    end
    
  end

  def index

    # if @categories=="" && @styles ==""
    #     @shops = Shop.all
    #   else
    #     @shops = Shop.tagged_with([@categories], :on => :categories, :any => true).tagged_with([@styles], :on => :styles, :any => true)
    #     return render :json=> {:message => "No match found"} if @shops.blank?
    #   end


    # if user_signed_in?
      # if params[:q]
      @q = Shop.ransack(params[:q])
      # @type = Shop.select(:shop_type).map(&:shop_type).uniq
      @shops = @q.result(distinct: true)
      
      # else
        # @shops = Shop.all
      # end

      if params[:tag]
        @shops = Shop.tagged_with(params[:tag])
      else
        @shops = Shop.all
      end
@categories = Shop.category_counts

    


  end



  def new
    @shop = Shop.new
    @photo = @shop.photos.build
  end

  def create
    @shop = current_user.shops.build(shop_params)
    if @shop.save
      if (params[:photos] != nil)
        params[:photos]['image'].each do |a|
          @photo = @shop.photos.create!(:image => a, :shop_id => @shop.id)
        end
      end
      flash[:success] = "Shop created!"
      redirect_to @shop
    else
      render 'new'
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])

    if @shop.update_attributes(shop_params)
      redirect_to @shop, notice: "Successfully updated shop"
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to root_url
  end

  def show
    @user = current_user
    @shop = Shop.find(params[:id])
    @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
    @comment = Comment.new 
    @comments =  @shop.comment_feed.paginate(page: params[:page])

    @photos = @shop.photos.all

    @related = Shop.tagged_with(@shop.style_list, :any => true, :order_by_matching_tag_count => true).limit(5)
   
  end

  def rate
    @shop = Shop.find(params[:id])
    
    @shop.liked_by current_user, :vote_weight => params[:rating]

    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end


  def unrate
    @shop = Shop.find(params[:id])
    @shop.unliked_by current_user
   

    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end
  private
  def shop_params
    params.require(:shop).permit(:shop_type,
                  :name,
                  :description,
                  :phone,
                  :address,
                  :details,
                  :email,
                  :tag_list,
                  :category_list,
                  :style_list,
                  photos_attributes: [:id, :shop_id, :image])
  end


  def correct_user
        @shop = current_user.shops.find_by(id: params[:id])
        redirect_to root_url if @shop.nil?
  end

  def client_user
      redirect_to root_url if (current_user.role =="client")
  end


  def set_search
    @q=Shop.ransack(params[:q])
  end

end

