class Studentgroup < ActiveRecord::Base
  belongs_to :course
  has_many :users
  # attr_accessible :title, :body
end
