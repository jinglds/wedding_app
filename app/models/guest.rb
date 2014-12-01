class Guest < ActiveRecord::Base
	before_save :lowercase_params
	belongs_to :event
	belongs_to :user
	validates :name, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true

  	scope :attendees, -> { where(attending: 't') }
  	scope :inviteds, -> { where(invitation_sent: 't') }
  	scope :bride, -> { where(side: 'bride') }
  	scope :groom, -> { where(side: 'groom') }

  	def lowercase_params
  		self.group.downcase!
  	end

    def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |guest|
        csv << guest.attributes.values_at(*column_names)
      end
    end
  end
end
