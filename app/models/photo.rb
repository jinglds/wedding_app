class Photo < ActiveRecord::Base
	dragonfly_accessor :image do
	    default 'assets/images/shop-default.jpg'
	  end
	belongs_to :shop

	# validates :title, presence: true, length: {minimum: 2, maximum: 20}

	validates :image, presence: true
	validates_size_of :image, maximum: 500.kilobytes,
	                  message: "should be no more than 500 KB", if: :image_changed?
	 
	validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
	                   message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?
	# validates_property :width, of: :image, in: (0..400),
                           # message: proc{ |actual, model| "Unlucky #{model.title} - was #{actual}" }
    scope :is_cover, -> { where(cover: 't') }

    def self.is_cover(params)
    	@shop = Shop.find(params[:shop_id])
    	@cover = @shop.photos.find_by_cover(true)
    end

end
