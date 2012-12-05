class FileSubmission < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :user_id, :assignment_definition_id
  

end
