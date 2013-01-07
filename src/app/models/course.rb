class Course < ActiveRecord::Base
  belongs_to :user
  has_one :studentgroup
  has_one :tagroup
  attr_accessible :course_number, :name, :section, :term, :user_id

end
