class QuestionExtra < ActiveRecord::Base
	 belongs_to :review_question
   attr_accessible :review_question_id,:extra
end
