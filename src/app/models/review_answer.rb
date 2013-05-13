class ReviewAnswer < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_question
	
  attr_accessible :answer, :review_question_id, :user_id, :other_id
  
  def review_mapping
    ReviewMapping.find_by_user_id_and_other_user_id_and_review_assignment_id(user_id, other_id, review_question.review_assignment.id)
  end
  
end
