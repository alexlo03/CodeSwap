class FacultyReview < ActiveRecord::Base
  attr_accessible :content, :review_mapping_id
  
  has_one :review_mapping
  
  
  
end
