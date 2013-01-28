class ReviewAssignment < ActiveRecord::Base
	belongs_to :user
	belongs_to :assignment
	belongs_to :course
	belongs_to :assignment_pairing

  attr_accessible :assignment_id, :assignment_pairing_id, :course_id, :end_date, :start_date, :user_id
end
