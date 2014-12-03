class User < ActiveRecord::Base
	# include TokenAuthenticatable
	acts_as_token_authenticatable
	acts_as_voter


	before_save :ensure_authentication_token
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	has_many :articles
	has_many :tasks, dependent: :destroy
	has_many :checklists, dependent: :destroy
	has_many :expenses, dependent: :destroy
	has_many :comments
	has_many :events, dependent: :destroy
	has_many :shops, dependent: :destroy
	has_many :vendors, dependent: :destroy
	has_many :favorites
	has_many :favorite_shops, through: :favorites, source: :favorited, source_type: 'Shop'
	has_many :guests
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable, :timeoutable
	validates :firstname, presence: true
	validates :lastname, presence: true
	# validates :address, presence: true
	# validates :phone, presence: true
    after_create :assign_default_role


    scope :client_users, -> { where(role: 'client') }
    scope :enterprise_users, -> { where(role: 'enterprise') }
    scope :admin_users, -> { where(role: 'admin') }
    scope :pending_users, -> {where(approval: 't')}
	def assign_default_role
		self.role = :client if self.role.blank?
	end

	# def my_shops
	#     Shop.where("user_id =?", id)
	# end

	# def my_events
	#     Event.where("user_id =?", id)
	# end

	# def my_comments



	def timeout_in
	    if self.role=='admin'
	      7.days
	    else
	      2.days
	    end
	end
	#     Comment.where("user_id =?", id)
	# end
  def find_by_authentication_token(authentication_token = nil)
      if authentication_token
        where(authentication_token: authentication_token).first
      end
    
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def ensure_authentication_token!
  reset_authentication_token! if authentication_token.blank?
end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
    save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.unscoped.where(authentication_token: token).first
    end
  end

end
