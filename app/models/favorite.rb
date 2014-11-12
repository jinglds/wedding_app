class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorited, polymorphic: true

  # def method_name
  	
  # end
end
