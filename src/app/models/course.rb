class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :course_number, :name, :section, :term
end
