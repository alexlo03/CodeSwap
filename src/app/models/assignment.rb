class Assignment < ActiveRecord::Base
    #Find deprecated methods at the bottom of this class!
  # attr_accessible :title, :body
  belongs_to :course
  has_many :assignment_definitions
  attr_accessible :start_date, :end_date, :name, :description, :course_id, :hidden

  def course
    Course.find(course_id)
  end
    
  def has_not_started
      
  end
    
  def has_not_started?
      start_date > Time.now
  end
    
    
    
    
  def is_active
  end
    
  def is_active?
      (start_date <= Time.now) && (Time.now <= end_date_buffered)
  end

   
    
  def is_over
    
  end
    
  def is_over?
      end_date_buffered < Time.now
  end
    
    
  
  def is_late
    
  end
    
  def is_late?
      end_date_buffered < Time.now && (end_date_buffered + 24.hours) > Time.now
  end
    
    
  
  def end_date_buffered
    end_date + 15.minutes
  end
  
  def pretty_start_date
    start_date.strftime("%m-%d-%y  %l:%M %P %Z")
  end
  
  def pretty_end_date
    end_date.strftime("%m-%d-%y  %l:%M %P %Z")
  end

	#Get the faculty file submissions, used to filter out results for downloads
	def getFacultyFileSubmissions
		course = Course.find(course_id)
		FileSubmission.where(:user_id => course.user_id, :assignment_id => id)
	end
  
  def user_can_download_all(current_user_id)
    applicable_users = []
    applicable_users += User.find_all_by_role("admin").collect(&:id)
    applicable_users += [self.course.user_id]
    applicable_users += self.course.get_tas
    return applicable_users.include?(current_user_id)
  end
    
    #DEPRECATED METHODS:
    deprecated :has_not_started, :has_not_started?
    deprecated :is_over, :is_over?
    deprecated :is_late, :is_late?
    deprecated :is_active, :is_active?
    
end
