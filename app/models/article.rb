class Article < ActiveRecord::Base

	before_save :lowercase_params
	belongs_to :user
	validates :title, presence: true
	validates :content, presence: true
	validates :category, presence: true

	def lowercase_params
  		self.category.downcase!
  	end
end
