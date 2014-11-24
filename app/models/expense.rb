class Expense < ActiveRecord::Base
	before_save :lowercase_params
	belongs_to :event
	belongs_to :user
	validates :title, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true
	validates :amount, presence: true, numericality: true

	def amount=(num)
	  self[:amount] = num.to_s.scan(/\b-?[\d.]+/).join.to_f
	end
  	def lowercase_params
  		self.expense_type.downcase!
  	end

end
