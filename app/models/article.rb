class Article < ActiveRecord::Base
	belongs_to :user
	validates :title, presence: true
	validates :content, presence: true
	validates :category, presence: true
end
