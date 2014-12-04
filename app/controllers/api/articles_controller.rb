module Api
  class ArticlesController < Api::BaseController
  

      def index
        @articles = Article.where(:published=>true)
      end

      def show
        @article = Article.find(params[:id])
        
      end

     
    end
  end
