class Lunch < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :day, presence: true
  validates :user_id, presence: true
  validates :name, presence: true


  

  
end
