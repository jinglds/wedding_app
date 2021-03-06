module Api
  class CommentsController < Api::BaseController
    skip_before_filter :verify_authenticity_token, only: [:create]
    before_filter :correct_user, only: [:destroy, :update, :pay, :unpay]

    def create
    	@shop = Shop.find(params[:shop_id])
      	@comment = @shop.comments.build(comment_params)
      	@comment.shop = @shop
      	@comment.user = app_user
      	@comment_items = @shop.comments
      	@comment.save
      	@comments =  @shop.comment_feed
      	@new = Comment.new
    	if @comment.save
          return render :json=> {:success => true, :comment => @comment}
        else
          return render :json=> {:success => false, :message => "comment not created"}
        end
    end

    def index
      @user = app_user
    	@shop = Shop.find(params[:shop_id])
    	@comments = @shop.comments.order(cached_votes_score: :desc, created_at: :desc)
    	
    end

    def like

    @comment = Comment.find(params[:id])
    if @comment.liked_by app_user
      return render :json=> {:success => true, :message => "comment liked", :comment => @comment}
    else
      return render :json=> {:success => false, :message => "comment not liked"}
    end
  end


  def unlike
    @comment = Comment.find(params[:id])
    if @comment.unliked_by app_user
      return render :json=> {:success => true, :message => "comment unliked", :comment => @comment}
    else
      return render :json=> {:success => false, :message => "comment not not unliked"}
    end

  end

    private
    def comment_params
	      params.require(:comment).permit(:content,
	      									:user_id,
	      									:comment_id,
                          					:title)
	end

    def app_user
        email =request.headers['X-User-Email'].to_s
        user = User.find_by_email(email)
    end


	end
end
