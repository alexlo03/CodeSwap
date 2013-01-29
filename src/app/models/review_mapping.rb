class ReviewMapping < ActiveRecord::Base
	belongs_to :user
	belongs_to :review_assignment

  attr_accessible :other_user_id, :review_assignment_id, :user_id
	
	def other_user
		User.find(other_user_id)
	end
end
