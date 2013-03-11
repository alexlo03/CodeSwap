class CourseGroup < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
  attr_accessible :course_id, :group, :user_id
end
