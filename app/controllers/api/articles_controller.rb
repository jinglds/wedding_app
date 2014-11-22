module Api
  class ArticlesController < Api::BaseController
  

      def index
        @articles = Article.all
      end

      def show
        @article = Article.find(params[:id])
        
      end

     
    end
  end
