class ReviewAnswer < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_question_id
	
  attr_accessible :answer, :review_question_id, :user_id
end
