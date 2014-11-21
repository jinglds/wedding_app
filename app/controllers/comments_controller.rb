class CommentsController < ApplicationController
  # before_action :signed_in_user, only: [:create, :destroy]


  def create
    @user = current_user
      @shop = Shop.find(params[:shop_id])
      @comment = @shop.comments.build(comment_params)
      @comment.shop = @shop
      @comment.user = current_user
      @comment_items = @shop.comments
      @comment.save
      @comments =  @shop.comment_feed
      @new = Comment.new
        # respond_to do |format|
      # if @comment.save
      #    flash[:success] = "Comment created!"
      #    redirect_to @shop
        
      # else
      #   flash[:success] = "Error!"
      #     render @shop
      # end
      respond_to do |format|
      format.html {render nothing: true}
      format.js
    end
  end

  def new
    @user = current_user
    @shop = Shop.find(params[:shop_id])
      @comments =  @shop.comment_feed.paginate(page: params[:page])

      @comment = @shop.comments.build(comment_params)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
    if @comment.update_attributes(comment_params)
      flash[:success] = "Successfully updated comment"
      redirect_to @shop
    else
      render :edit
    end
  end


  def destroy
      @shop= Shop.find(params[:shop_id])
      @comment = @shop.comments.find(params[:id])
      @comment.destroy



      flash[:success] = "Comment deleted!"
         redirect_to @comment
  end

	def like
    @user = current_user
    @comment = Comment.find(params[:id])
    comment = @comment
    @shop = @comment.shop
    @comments =  @shop.comment_feed.paginate(page: params[:page])

    @comment.liked_by current_user
    respond_to do |format|
      format.html {render layout: false}
      format.js
    end
  end


  def unlike
    @user = current_user
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
    @comments =  @shop.comment_feed.paginate(page: params[:page])
    @comment.unliked_by current_user
   

    respond_to do |format|
      format.html {render layout: false}
      format.js
    end
  end

	private

	    def comment_params
	      params.require(:comment).permit(:content,
	      									:user_id,
	      									:comment_id,
                          :title)
	    end

	    # def correct_user
	    #   @micropost = current_user.microposts.find_by(id: params[:id])
	    #   redirect_to root_url if @micropost.nil?
	    # end
	  
end