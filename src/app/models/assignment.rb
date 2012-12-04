class Assignment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :course
  has_many :assignment_definitions

  attr_accessible :start_date, :end_date, :name, :description, :course_id
end
