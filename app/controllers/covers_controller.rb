class CoversController < ApplicationController
	def index
		@covers = Cover.all
	end
	 
	def new
		@cover = Cover.new
	end
	 
	def create
		@cover = Cover.new(cover_params)
		if @cover.save
		    flash[:success] = "Cover saved!"
		    redirect_to covers_path
		else
		    render 'new'
		    end
	end
	# def show
	# 	@cover = Cover.find(params[:id])
 #    	@shop = Shop.find(params[:shop_id])
 #    end

	# def edit

	# 	@cover = Cover.find(params[:id])
 #    	@shop = Shop.find(params[:shop_id])
 #    	@covers = @shop.covers
	# end

	# def edit_gallery
 #    	@shop = Shop.find(params[:shop_id])
 #    	@covers = @shop.covers
	# end

	# def set_as_cover
	# 	@shop = Shop.find(params[:shop_id])
	# 	@cover = Cover.find(params[:id])
 #    	@covers = @shop.covers
 #    	if @covers.where(:cover => true).first
 #    		@covers.where(:cover => true).first.update_attributes(:cover => false)
 #    	end
 #    	if @cover.update_attributes(:cover => true)
 #    		@shop.update_attributes(:cover_url => @cover.image) 
	# 	redirect_to @shop, notice: "Set as cover "
 #    	else
 #      		render :set_as_cover
 #   		end
    
	# end
	# def update
	# 	@cover = Cover.find(params[:id])
	#   respond_to do |format|
	#     if @cover.update(cover_params)
	#       format.html { redirect_to @cover.shop, notice: 'Post attachment was successfully updated.' }
	#     end 
	#   end
	# end


	# def destroy
 #      @shop= Shop.find(params[:shop_id])
 #      @cover = @shop.covers.find(params[:id])
 #      @cover.destroy

 #      flash[:success] = "Expense deleted!"
 #         redirect_to @shop
  # end

	private
	def cover_params
    params.require(:cover).permit(:shop_id, :title, :image)
  end

end
