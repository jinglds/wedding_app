class ArticlesController < ApplicationController
	before_filter :admin_user, only: [:new, :create, :edit, :update, :destroy]

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
		@articles = Article.all
		
	end

	

	private
  	def article_params
  		params.require(:article).permit(:user_id,
  								:title,
                                :content,
                                :category)
  	end

  	def admin_user
  		current_user.admin?
  	end

end
