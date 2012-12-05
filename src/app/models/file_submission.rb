class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :user_id, :assignment_definition_id
  mount_uploader :file_submission, FileSubmissionUploader

  def to_jq_upload
    {
      "name" => read_attribute(:name)
    }
  end


end
