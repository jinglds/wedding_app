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
  	scope :this_month, -> { where("due_date >= ? AND due_date <= ?", 
  Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}

  	scope :this_week, -> { where("due_date >= ? AND due_date <= ?", 
  Time.zone.now.beginning_of_week, Time.zone.now.end_of_week)}

    # scope :today, -> { where(:created_at => (date.beginning_of_day..date.end_of_day))}
  	# def self.this_month
  	# 	where("EXTRACT(MONTH FROM due_date)) = ?", Date.today.month )
  	# end

    def self.today(params)
      @date = params[:date]
      @today_tasks = Task.where(:due_date => @date.beginning_of_day..@date.end_of_day)
      
    end

    def self.status(params)
      if Task.find(params[:task_id]).due_date < Date.today
        return "late"
      else
        return "ok"
      end

    end

end
