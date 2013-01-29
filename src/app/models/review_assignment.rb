class ReviewAssignment < ActiveRecord::Base
	belongs_to :user
	belongs_to :assignment
	belongs_to :course
	belongs_to :assignment_pairing

  attr_accessible :assignment_id, :assignment_pairing_id, :course_id, :end_date, :start_date, :user_id



	def	find_file_submission(user_id)
			assignment_id = self.assignment.id
			FileSubmission.find_by_user_id_and_assignment_id(user_id,assignment_id)
	end
end
