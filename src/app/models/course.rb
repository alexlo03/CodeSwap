class Course < ActiveRecord::Base
  has_many :users
  attr_accessible :course_number, :name, :section, :term
end
