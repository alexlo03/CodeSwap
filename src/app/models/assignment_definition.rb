class AssignmentDefinition < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :assignment
	has_one :assignment_pairing
  attr_accessible :description, :assignment_id
end
