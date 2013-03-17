class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :course
  belongs_to :user
  belongs_to :assignment_definition
  belongs_to :assignment
  attr_accessible :name, :user_id, :assignment_definition_id, :course_id, :assignment_id, :file
  
  mount_uploader :file, FileSubmissionUploader
  process_in_background :file
  
  def full_save_path
    return save_directory + name
  end

  # user = grader
  # other_user = gradee
  def user_can_download (current_user_id)
    applicable_users = []
    applicable_users += [user_id]
    applicable_users += self.course.get_tas
    applicable_users += [self.course.user_id]
    applicable_users += User.find_all_by_role("admin").collect(&:id)


    review_assignment = ReviewAssignment.find_by_assignment_id(assignment_id)
    unless(review_assignment.nil?)
     review_mapping = ReviewMapping.find_all_by_review_assignment_id_and_other_user_id(review_assignment.id, self.user_id)
     applicable_users += review_mapping.collect(&:user_id)
    end

    return current_user_id.in?(applicable_users)
  end

  def save_directory
    return 'Uploads/Assignments/Course ID' + course_id.to_s + '/Assignment ID' + assignment_id.to_s + '/' + User.find(user_id).username + '/'
  end
end
