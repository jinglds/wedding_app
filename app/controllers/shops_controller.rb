class ShopsController < ApplicationController
  before_filter :store_location, only: [:create, :destroy, :index, :show, :edit]
  before_filter :authenticate_user!
  before_action :correct_user,   only: [:destroy, :edit]
  before_action :client_user, only: [:new, :create, :destroy]
  # before_filter :set_search, only: :index


  def category
    
    @categories = Shop.category_counts

   
    # @cat = params[:category] ? params[:category] : "all"
      if params[:category]=="" && params[:styles] ==""
        @shops = Shop.all
      elsif params[:category]!="" && params[:styles] ==""
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true)
        
      elsif params[:category]=="" && params[:styles]!=""
        @shops = Shop.tagged_with(params[:styles], :on => :styles, :any => true)
      else
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true).tagged_with(params[:styles], :on => :styles, :any => true)
      end

      @styles = @shops.tag_counts_on(:styles)

    @c=params[:category]
    @s=params[:styles].to_s
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
      # @cat = params[:category]
      if params[:category]=="" && params[:styles] ==""
        @shops = Shop.all
      elsif params[:category]!="" && params[:styles] ==""
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true)

      elsif params[:category]=="" && params[:styles]!=""
        @shops = Shop.tagged_with(params[:styles], :on => :styles, :any => true)
      else
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true).tagged_with(params[:styles], :on => :styles, :any => true)
      end

    #     return render :json=> {:message => "No match found"} if @shops.blank?
    #   end
      @q = Shop.ransack(params[:q])
      # @type = Shop.select(:shop_type).map(&:shop_type).uniq
      @shops = @q.result(distinct: true)

      # else
        # @shops = Shop.all
      # end
  @categories = Shop.category_counts
@s = Shop.tagged_with("music")
sql = "select name as name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where tag_id=1) and context like 'styles'))"
results = ActiveRecord::Base.connection.execute(sql)
@r = results.as_json
   @styles = @r.to_json
   # @s = ShopTag.new
   # @s = @styles.map{|a| a.slice(:name, :count) }
   # @s.from_json(@styles)
   # @styles = Shop.find(records_array)
   # @styles = ActsAsTaggableOn.find(:conditions=> "select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where tag_id=1) and context like 'styles')")
    @c = "All Vendors"
    @c=params[:category].to_s if params[:category]
    @s=params[:styles]

respond_to do |format|
      format.html 
      format.js
    end

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

