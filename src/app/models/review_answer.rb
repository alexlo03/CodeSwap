class ReviewAnswer < ActiveRecord::Base
  attr_accessible :answer, :review_question_id, :user_id
end
