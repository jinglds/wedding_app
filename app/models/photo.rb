class Photo < ActiveRecord::Base
	mount_uploader :image, ImageUploader
  	belongs_to :shop

  def self.cur_cover
  	 where(cover: 't') 
  	
  end
  	
end

