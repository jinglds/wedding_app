class Guest < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	validates :name, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true

  	scope :attendees, -> { where(attending: 't') }
  	scope :inviteds, -> { where(invitation_sent: 't') }
end
