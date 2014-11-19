class Vendor < ActiveRecord::Base
	has_many :tasks
	belongs_to :user
	validates :user_id, presence: true
	validates :name, presence: true
	has_many :event_vendors
  	has_many :events, through: :event_vendors
  	belongs_to :shop
end

