class Event < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :event_type, presence: true
	validates :name, presence: true
	# validates :date, presence: true
	# validates :time, presence: true
	validates :budget, presence: true
	validates :bride_name, presence: true
	validates :groom_name, presence: true

end

