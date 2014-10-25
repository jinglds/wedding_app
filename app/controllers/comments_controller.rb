class CommentsController < ApplicationController
  # before_action :signed_in_user, only: [:create, :destroy]


	def create
	  	@shop = Shop.find(params[:shop_id])
	    @comment = @shop.comments.build(comment_params)
	    @comment.shop = @shop
	    @comment.user = current_user
	    @comment_items = @shop.comments

	      # respond_to do |format|
	    if @comment.save
	       flash[:success] = "Comment created!"
	       redirect_to @shop
	      
	    else
	    	flash[:success] = "Error!"
	        render @shop
	    end
	end

	def new
	    @comment = @shop.comments.build(comment_params)
	end

	def destroy
	    @shop= Shop.find(params[:shop_id])
	    @comment = @shop.comments.find(params[:id])
	    @comment.destroy



	    flash[:success] = "Comment deleted!"
	       redirect_to @shop
	end

	private

	    def comment_params
	      params.require(:comment).permit(:content,
	      									:user_id,
	      									:shop_id)
	    end

	    # def correct_user
	    #   @micropost = current_user.microposts.find_by(id: params[:id])
	    #   redirect_to root_url if @micropost.nil?
	    # end
	  
end