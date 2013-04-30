class ReviewAssignment < ActiveRecord::Base
	extend Deprecated
	belongs_to :user
	belongs_to :assignment
	belongs_to :course
	belongs_to :assignment_pairing
	has_many :review_questions

  attr_accessible :assignment_id, :assignment_pairing_id, :course_id, :end_date, :start_date, :user_id, :grouped



	# Finds the file submission for a user for this assignment
	# [Params]
	## * user_id -- the user id
	# [Return]
	## * File_Submission object
	def	find_file_submission(user_id)
			assignment_id = self.assignment.id
			FileSubmission.find_by_user_id_and_assignment_id(user_id,assignment_id)
	end

	# Finds the person the the user is supposed to grade
	# [Return]
	## * The matching user
	def find_pair(user_id)
			ReviewMapping.find_by_user_id_and_review_assignment_id(user_id,self.id).other_user
	end

	# Proper syntax for grouped boolean field
	# [Return]
	## * grouped
	def grouped?
		grouped
	end
	
  
	# Formats the start_date to be human readable string
	# [Return]
	## * String of the start_date
	# [Note]
	## * Uses String.strftime("%m-%d-%y  %l:%M %P %Z")
  def pretty_start_date
    start_date.strftime("%m-%d-%y  %l:%M %P %Z")
  end
  
	# Formats the end_date to be human readable string
	# [Return]
	## * String of the end_date
	# [Note]
	## * Uses String.strftime("%m-%d-%y  %l:%M %P %Z")
  def pretty_end_date
    end_date.strftime("%m-%d-%y  %l:%M %P %Z")
  end

  # Checks if the current time is between the start date and end date
	# [Return]
	## * True if Time.now between start_date and end_date, false otherwise    
  def is_active?
      (start_date <= Time.now) && (Time.now <= end_date_buffered)
  end
    
  # Checks if Time.now is greater than the end_date for the assignment  
	# [Return]
	## * True if Time.now greater than end_date, false otherwise
  def is_over?
      end_date_buffered < Time.now
  end

  # Checks if Time.now is between the end date and the late assignment buffer
	# [Return]
	## * True if Time.now greater than end_date and less than end_date + buffer, false otherwise 
	# [Note]
	## * Late window is 24 hours. Used to color tables in view so professor knows how late assignment was.
  def is_late?
      end_date_buffered < Time.now && (end_date_buffered + 24.hours) > Time.now
  end

  # Adds buffer to end_date, used to allow for network congestion and near end_time submissions
	# [Return]
	## * end_date + 15.minutes
  def end_date_buffered
    end_date + 15.minutes
  end

	# Converts the review_assignments grades into a csv
	# [Params]
	## * mappings -- hash of the student mappings
	## * questions -- all questions for this assignment
	## * answers -- all answers for this assignment
	# [Return]
	## * CSV that can be sent to the client 
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

	    #DEPRECATED METHODS:
 deprecated :is_over, :is_over?
 deprecated :is_late, :is_late?
 deprecated :is_active, :is_active?
end
