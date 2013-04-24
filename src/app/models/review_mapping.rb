class ReviewMapping < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_assignment

  attr_accessible :other_user_id, :review_assignment_id, :user_id
	
	# Gets the other user for a mapping
	## [Return]
	## * The other user 
	def other_user
		User.find(other_user_id)
	end
end
