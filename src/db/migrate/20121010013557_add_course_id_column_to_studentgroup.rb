class AddCourseIdColumnToStudentgroup < ActiveRecord::Migration
  def change 
    add_column :studentgroups, :course_id, :integer
  end
end
