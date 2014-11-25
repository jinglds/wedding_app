class Task < ActiveRecord::Base
 
	has_ancestry
	acts_as_taggable
	belongs_to :event
	belongs_to :user
  belongs_to :vendor
	validates :title, presence: true

  	validates :user_id, presence: true
  	validates :event_id, presence: true
  	# validates :due_date, presence: true


  	scope :done, -> { where(completed: 't').order('due_date') }
  	scope :not_done, -> { where(completed: 'f').order('due_date') }
  	scope :now, -> { where(rank: '0', completed: 'f').order('due_date') }
  	scope :this_month, -> { where("due_date >= ? AND due_date <= ?", 
  Time.zone.now.beginning_of_month, Time.zone.now.end_of_month).order('due_date')}

  	scope :this_week, -> { where("due_date >= ? AND due_date <= ?", 
  Time.zone.now.beginning_of_week, Time.zone.now.end_of_week).order('due_date')}
    scope :upcomings, -> { where("due_date >= ? AND due_date <= ?", 
  Time.zone.now.tomorrow.beginning_of_day, Time.zone.now.tomorrow.end_of_day+30.days).order('due_date')}
    scope :lates, -> { where("due_date <= ?", 
  Time.zone.now).order('due_date')}

    # scope :today, -> { where(:created_at => (date.beginning_of_day..date.end_of_day))}
  	# def self.this_month
  	# 	where("EXTRACT(MONTH FROM due_date)) = ?", Date.today.month )
  	# end

    def self.of_month(params)
      self.where("due_date >= ? AND due_date <= ?", 
      Chronic.parse("#{params}").beginning_of_month, Chronic.parse("#{params}").end_of_month).order('due_date')
    end

    def self.of_date(params)
      self.where("due_date >= ? AND due_date <= ?", 
      Chronic.parse("#{params}").beginning_of_day, Chronic.parse("#{params}").end_of_day).order('due_date')
    end

    def self.today(params)
      @date = params[:date]
      @today_tasks = Task.where(:due_date => @date.beginning_of_day..@date.end_of_day).order('due_date')
      
    end

    def self.status(params)
      if Task.find(params[:task_id]).due_date < Time.zone.now
        return "late"
      elsif Task.find(params[:task_id]).due_date < Date.today+1
        return "warning"
      else
        return "ok"
      end

    end

    def self.completed?
      self.completed == true
    end

end
