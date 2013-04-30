class ReviewMapping < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_assignment

  attr_accessible :other_user_id, :review_assignment_id, :user_id
	
	# Gets the other user for a mapping
	## [Return]
	## * The other user 
	def other_user
		User.find(other_user_id)
	end
	
	def completed?
	  questions = ReviewQuestion.find_all_by_review_assignment_id(review_assignment_id).collect(&:id)
	  return ReviewAnswer.find_all_by_user_id_and_other_id_and_review_question_id(self.user_id, self.other_user_id, questions).count > 0
	end
end	
