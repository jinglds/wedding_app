class ArticlesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :admin_user

	def publish
		@articles = Article.all
	    @article = Article.find(params[:article_id])
	    @article.update_attributes(:published => true) 

	    # respond_to do |format|
	    #   format.html { render :layout => false }
	    #   format.js
	    # end
	    redirect_to articles_path
	  end

	  def unpublish

		@articles = Article.all
	    @article = Article.find(params[:article_id])
	    @article.update_attributes(:published => false) 

	    # respond_to do |format|
	    #   format.html { render :layout => false }
	    #   format.js
	    # end

	    redirect_to articles_path
	  end

	def new
		@article = Article.new
	end

	def create
		@article = current_user.articles.build(article_params)
		if @article.save
			flash[:success] = "Article added!"
			redirect_to @article
		else
			flash[:danger] = "Error!"
			render new
		end
	end

	def index
		@articles = Article.all.order(updated_at: :desc)
		
	end

	def show
	    @article = Article.find(params[:id])
	end

	def destroy
	  	@article = current_user.articles.find(params[:id])
	  	@article.destroy

	  	flash[:success] = "Article deleted!"
	    redirect_to articles_path
  	end

	def edit
	    @article = Article.find(params[:id])
	end

  	def update
    	@article = Article.find(params[:id])

	    if @article.update_attributes(article_params)
	      redirect_to articles_path, notice: "Successfully updated event"
	    else
	      render :edit
	    end
  	end




	private
  	def article_params
  		params.require(:article).permit(:user_id,
  								:title,
                                :content,
                                :category,
                                :published)
  	end

  	def admin_user
  		redirect_to root_path unless current_user.role =="admin"
  	end

end
