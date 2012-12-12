class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :user_id, :assignment_definition_id, :course_id, :assignment_id
  
  def full_save_path
    return save_directory + '/' + name
  end

  def save_directory
    return 'Uploads/Assignments/' + course_id.to_s + '/' + assignment_id.to_s + '/' + user_id.to_s + '/'
  end
end
