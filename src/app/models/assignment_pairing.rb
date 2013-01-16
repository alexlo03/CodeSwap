class AssignmentPairing < ActiveRecord::Base
	belongs_to :assignment_definition
	belongs_to :assignment_pairing, :foreign_key => :previous_id 
	
  attr_accessible :assignment_definition_id, :depth, :number_of_graders, :previous_id, :seed
end
