class ReviewAssignment < ActiveRecord::Base
	belongs_to :user
	belongs_to :assignment
	belongs_to :course
	belongs_to :assignment_pairing
	has_many :review_questions

  attr_accessible :assignment_id, :assignment_pairing_id, :course_id, :end_date, :start_date, :user_id



	def	find_file_submission(user_id)
			assignment_id = self.assignment.id
			FileSubmission.find_by_user_id_and_assignment_id(user_id,assignment_id)
	end

	def find_pair(user_id)
			ReviewMapping.find_by_user_id_and_review_assignment_id(user_id,self.id).other_user
	end
end
