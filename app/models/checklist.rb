class Checklist < ActiveRecord::Base
	belongs_to :event
	belongs_to :user

	validates :title, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true

  	scope :done, -> { where(completed: 't').order('due_date') }
  	scope :not_done, -> { where(completed: 'f').order('due_date') }
end
