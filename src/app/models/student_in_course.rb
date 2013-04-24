class StudentInCourse < ActiveRecord::Base
  belongs_to :course
  has_many :users
  # attr_accessible :title, :body
  attr_accessible :user_id, :course_id
end
