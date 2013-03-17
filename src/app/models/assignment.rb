class Assignment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :course
  has_many :assignment_definitions
  attr_accessible :start_date, :end_date, :name, :description, :course_id, :hidden
  
  def course
    Course.find(course_id)
  end

  def has_not_started
    start_date > Time.now
  end

  def is_active
    (start_date <= Time.now) && (Time.now <= end_date)
  end

  def is_over
    end_date < Time.now
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
end
