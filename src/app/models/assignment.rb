class Assignment < ActiveRecord::Base
  #Find deprecated methods at the bottom of this class!
	extend Deprecated
  belongs_to :course
  has_many :assignment_definitions
  attr_accessible :start_date, :end_date, :name, :description, :course_id, :hidden

  
  # Checks if an assignment has not started
	# [Return]
	## * True if start date is after Time.now, false otherwise
	# [Note]
	## * DEPRECATED: Use has_not_started? instead
  def has_not_started
      
  end
  
  # Checks if an assignment has not started
	# [Return]
	## * True if start date is after Time.now, false otherwise
  def has_not_started?
      start_date > Time.now
  end
    
    
    
  # Checks if the current time is between the start date and end date
	# [Return]
	## * True if Time.now between start_date and end_date, false otherwise
	# [Note]
	## * DEPRECATED: Use is_active? instead
  def is_active
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
	# [Note]
	## * DEPRECATED: Use is_over? instead
  def is_over
    
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
	## * DEPRECATED: Use is_late? instead
	## * Late window is 24 hours. Used to color tables in view so professor knows how late assignment was.
  def is_late
    
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
	
	# Returns an array of file submissions that belong to the course owner
	# [Return]
	## * Array of faculties file submissions
	def getFacultyFileSubmissions
		course = Course.find(course_id)
		FileSubmission.where(:user_id => course.user_id, :assignment_id => id)
	end
  
	# Returns the mapping used to assign students to each other
	# [Return]
	## * Hash of student ID's
	# [Note]
	## * See pairing helper for more details on how pairings are created
	def assignment_pairings
		ret = []
			defs = assignment_definitions
			defs.each do |assignment_definition|
				ret += AssignmentPairing.find_all_by_assignment_definition_id[assignment_definition.id]
			end
		return ret
	end

	# Checks if a user can download all files for an assignment
	# [Return]
	## * True if one of the following, false otherwise:
	##    1. User is an admin
	##    2. User is the faculty of the course
	##    3. User is a TA for the course
  def user_can_download_all(user_id)
    applicable_users = []
    applicable_users += User.find_all_by_role("admin").collect(&:id)
    applicable_users += [self.course.user_id]
    applicable_users += self.course.get_tas
    return applicable_users.include?(user_id)
  end
    
    #DEPRECATED METHODS:
    deprecated :has_not_started, :has_not_started?
    deprecated :is_over, :is_over?
    deprecated :is_late, :is_late?
    deprecated :is_active, :is_active?
    
end
