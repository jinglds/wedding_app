class Collaboration < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	validates :user_id, presence: true
	validates :event_id, presence: true


  	scope :requests, -> { where(accepted: false) }
  	scope :joined, -> { where(accepted: true) }
end

