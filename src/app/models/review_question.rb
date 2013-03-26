class ReviewQuestion < ActiveRecord::Base
	belongs_to :review_assignment
	has_many :question_extras
	
  attr_accessible :content, :question_type, :review_assignment_id
	
	#for the different types 
  #instruction = 0
	#multiple_choice = 1
	#numerical_answer = 2
	#short_answer = 3
	TYPES = %w{instruction multiple_choice numerical_answer short_answer}

	TYPES.each_with_index do |name,i|
		define_method("#{name}?") {question_type == i}
	end

	def set_type(type_string)
		TYPES.each_with_index do |name,i|
			if name == type_string
				self.question_type = i
			end
		end
	end

end
