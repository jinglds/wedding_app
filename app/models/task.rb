class Task < ActiveRecord::Base
	acts_as_taggable
	belongs_to :event
	belongs_to :user
	validates :title, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true
  	validates :due_date, presence: true


end
