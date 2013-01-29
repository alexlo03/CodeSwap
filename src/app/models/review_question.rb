class ReviewQuestion < ActiveRecord::Base
	belongs_to :review_assignment
  attr_accessible :content, :question_type, :review_assignment_id
	
	#for the different types
	#multipleChoice = 1
	#numerical = 2
	#shortAnswer = 3
	TYPES = %w{ multipleChoice numerical shortAnswer }

	TYPES.each_with_index do |name,i|
		define_method("#{name}?") {question_type == i}
	end

	
end
