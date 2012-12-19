class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :user_id, :assignment_definition_id, :course_id, :assignment_id, :file
  
  mount_uploader :file, FileSubmissionUploader

  def full_save_path
    return save_directory + '/' + name
  end

  def save_directory
    return 'Uploads/Assignments/Course ID' + course_id.to_s + '/Assignment ID' + assignment_id.to_s + '/' + User.find(user_id).username + '/'
  end
end
