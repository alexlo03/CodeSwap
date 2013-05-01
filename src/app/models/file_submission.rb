class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :course
  belongs_to :user
  belongs_to :assignment_definition
  belongs_to :assignment
  attr_accessible :name, :user_id, :assignment_definition_id, :course_id, :assignment_id, :file, :uploaded_by
  
  mount_uploader :file, FileSubmissionUploader
  process_in_background :file
  
  # Full save path for a file
  ## [Return]
  ## * The full save path
  def full_save_path
    return save_directory + name
  end
	
  # Checks if a user can download a file
  ## [Params]
  ## * user_id -- the user to check
  ## [Return]
  ## * True if a user has permission to download the file, otherwise false
  def user_can_download (current_user_id)
    applicable_users = []
    applicable_users += [self.user_id]
    applicable_users += self.course.get_tas
    applicable_users += [self.course.user_id]
    applicable_users += User.find_all_by_role("admin").collect(&:id)

    if (self.user_id == self.course.user_id)
      applicable_users += self.course.get_students
    else
      review_assignment = ReviewAssignment.find_by_assignment_id(self.assignment_id)
      unless(review_assignment.nil?)
       review_mapping = ReviewMapping.find_all_by_review_assignment_id_and_other_user_id(review_assignment.id, self.user_id)
       applicable_users += review_mapping.collect(&:user_id)
      end
    end
    return current_user_id.in?(applicable_users)
  end
  

  # Checks if a user can download a file
  ## [Params]
  ## * user_id -- the user to check
  ## [Return]
  ## * True if a user has permission to download the file, otherwise false
  def user_can_delete (current_user_id)
    applicable_users = []
    applicable_users += [self.user_id]
    applicable_users += self.course.get_tas
    applicable_users += [self.course.user_id]
    applicable_users += User.find_all_by_role("admin").collect(&:id)

    return current_user_id.in?(applicable_users)
  end

  # Full save directory
  ## [Return]
  ## * Returns the full save directory
  def save_directory
    return 'Uploads/Assignments/Course ID#{course_id.to_s}/Assignment ID#{assignment_id.to_s}/#{User.find(user_id).username}/'
  end
end
