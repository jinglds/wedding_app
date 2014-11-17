class ShopsController < ApplicationController
  before_filter :store_location, only: [:create, :destroy, :index, :show, :edit]
  before_filter :authenticate_user!
  before_action :correct_user,   only: [:destroy, :edit]
  before_action :client_user, only: [:new, :create, :destroy]
  # before_filter :set_search, only: :index


  def category
    
    @categories = Shop.category_counts
      

    @c=params[:category].to_s if params[:category]
    @s=params[:styles].to_s if params[:styles]
    
    sql = "select distinct name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where (select tag_id from tags where name like '#{@c}')) and context like 'styles'))"
    
    if params[:category]=="" && params[:styles] ==""
        @shops = Shop.all
        @c = ""
        @s = ""
        @cat_title = "All"
        sql = "select distinct name, taggings_count as count from tags where id in (select tag_id from taggings where context like 'styles')"
      elsif params[:category]!="" && params[:styles] ==""
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true)
        @cat_title = params[:category]
        sql = "select distinct name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where (select tag_id from tags where name like '#{@c}')) and context like 'styles'))"
      elsif (params[:category]=="" || params[:category].nil?) && params[:styles]!=""
        @shops = Shop.tagged_with(params[:styles], :on => :styles, :any => true)
        @c = ""
        @cat_title = "All"
        sql = "select distinct name, taggings_count as count from tags where id in (select tag_id from taggings where context like 'styles')"

      else
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true).tagged_with(params[:styles], :on => :styles, :any => true)
        @cat_title = params[:category]
        sql = "select distinct name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where (select tag_id from tags where name like '#{@c}')) and context like 'styles'))"
    
      end

    @styles = @shops.tag_counts_on(:styles)
      
    @results = ActiveRecord::Base.connection.execute(sql)

    respond_to do |format|
      format.html 
      format.js
    end
    
  end

  def index
    @categories = Shop.category_counts
      

    @cat_title = "All Vendors"
    @c=""
    @s=params[:styles].to_s if params[:styles]
    
    sql = "select distinct name, taggings_count as count from tags where id in (select tag_id from taggings where context like 'styles')"
      
    if (params[:category]=="" || params[:category].nil?) && (params[:styles] =="" || params[:styles].nil?) 
        @shops = Shop.all
        @c = ""
        @s = ""
        @cat_title = "All"
        sql = "select distinct name, taggings_count as count from tags where id in (select tag_id from taggings where context like 'styles')"
      elsif params[:category]!="" && params[:styles] ==""
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true)
        @cat_title = params[:category].to_s
        sql = "select distinct name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where (select tag_id from tags where name like '#{@c}')) and context like 'styles'))"
    
      elsif (params[:category]=="" || params[:category].nil?) && params[:styles]!=""
        @shops = Shop.tagged_with(params[:styles], :on => :styles, :any => true)
        @c = ""
        @cat_title = "All"
        sql = "select distinct name, taggings_count as count from tags where id in (select tag_id from taggings where context like 'styles')"

      else
        @shops = Shop.tagged_with(params[:category], :on => :categories, :any => true).tagged_with(params[:styles], :on => :styles, :any => true)
        @cat_title = params[:category].to_s
        sql = "select distinct name, taggings_count as count from tags where id in (select distinct tag_id from taggings where ( taggable_id in (select distinct taggable_id from taggings where (select tag_id from tags where name like '#{@c}')) and context like 'styles'))"
    
      end

      
      @cat_title = @cat_title.intern
      @results = ActiveRecord::Base.connection.execute(sql)
      @results = @results
      @q = Shop.ransack(params[:q])
      # @type = Shop.select(:shop_type).map(&:shop_type).uniq
      @shops = @q.result(distinct: true)

    @styles = @shops.tag_counts_on(:styles)
      # else
        # @shops = Shop.all
      # end
      @shops = @shops.paginate(page: params[:page])

  @categories = Shop.category_counts

respond_to do |format|
      format.html 
      format.js
    end

  end



  def new
    @shop = Shop.new
    # @photo = @shop.photos.build

    # respond_to do |format|
    #   format.html 
    #   format.js
    # end
  end

  def create
    @shop = current_user.shops.build(shop_params)
    # unless params[:photos].nil?
    #   params[:photos].each do |a|
    #     @photo = @shop.photos.create!(:image => a, :shop_id => @shop.id)
    #   end
    # end
    if @shop.save
      respond_to do |format|
      format.html {redirect_to shop_new_gallery_path(@shop)}
      format.js
      end
    else
      respond_to do |format|
      format.html {render 'new'}
      format.js
      end 
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
    redirect_to myshops_path
  end

  def show
    @user = current_user
    @shop = Shop.find(params[:id])
    @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
    if @ratings.nan?
      @ratings = 0.0
    end
    @comment = Comment.new 
    @comments =  @shop.comment_feed.paginate(page: params[:page])

    @photos = @shop.photos.all
    @cover = Photo.is_cover(:shop_id => @shop.id)
    @recommendations = Shop.tagged_with(@shop.style_list, :any => true, :order_by_matching_tag_count => true).limit(4)
    @favorite = @user.favorites.find_by(favorited_id: @shop.id)
  end

  def rate
    @user = current_user
    @shop = Shop.find(params[:id])
    
    @shop.liked_by current_user, :vote_weight => params[:rating]

    @ratings = (@shop.get_upvotes.sum(:vote_weight).to_f / @shop.get_upvotes.size)
    if @ratings.nan?
      @ratings = 0.0
    end

    respond_to do |format|
      format.html { render nothing: true }
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
                  :style_list)
                  # photos_attributes: [:shop_id, :image])
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

