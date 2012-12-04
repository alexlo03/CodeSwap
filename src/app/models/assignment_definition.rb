class AssignmentDefinition < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :assignment

  attr_accessible :description, :assignment_id
end
