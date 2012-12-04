class AssignmentDefinitionToUser < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :assignment_definition

  has_many :users

  attr_accessible :assignment_definition_id, :user_id

end
