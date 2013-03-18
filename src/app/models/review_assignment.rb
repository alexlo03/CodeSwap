class ReviewAssignment < ActiveRecord::Base
	belongs_to :user
	belongs_to :assignment
	belongs_to :course
	belongs_to :assignment_pairing
	has_many :review_questions

  attr_accessible :assignment_id, :assignment_pairing_id, :course_id, :end_date, :start_date, :user_id, :grouped



	def	find_file_submission(user_id)
			assignment_id = self.assignment.id
			FileSubmission.find_by_user_id_and_assignment_id(user_id,assignment_id)
	end

	def find_pair(user_id)
			ReviewMapping.find_by_user_id_and_review_assignment_id(user_id,self.id).other_user
	end


	def grouped?
		grouped
	end
	
	def pretty_start_date
    start_date.strftime("%m-%d-%y  %l:%M %P")
  end
  
  def pretty_end_date
    end_date.strftime("%m-%d-%y  %l:%M %P")
  end
	

	def to_csv(mappings, questions, answers)
		CSV.generate do |csv|
			csv << ["Grader", "Grader Email", "Graded", "Graded Email"] + questions.map{|question| "#{question.content.split("@#!$")[0]}"}
			mappings.each do |mapping|
				student = mapping.user
				other = mapping.other_user
				csv << ["#{student.friendly_full_name}", "#{student.email}", "#{other.friendly_full_name}", "#{other.email}"] + answers[mapping.id].map{|answer| "#{answer.answer}"}
			end
		end
	end
end
