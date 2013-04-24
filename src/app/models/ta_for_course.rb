class TaForCourse < ActiveRecord::Base
  belongs_to :course
  has_many :users
  # attr_accessible :title, :body
  attr_accessible :course_id, :user_id
end
