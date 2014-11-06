class Task < ActiveRecord::Base
	has_ancestry
	acts_as_taggable
	belongs_to :event
	belongs_to :user
	validates :title, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true
  	# validates :due_date, presence: true

  	scope :done, -> { where(completed: 't') }
  	scope :not_done, -> { where(completed: 'f') }
  	scope :now, -> { where(rank: '0', completed: 'f') }


end
