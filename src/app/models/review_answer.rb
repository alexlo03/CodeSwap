class ReviewAnswer < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_question
	
  attr_accessible :answer, :review_question_id, :user_id, :other_id
end
