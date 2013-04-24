class RenameStudentgroupToStudentInCourse < ActiveRecord::Migration
  def up
    rename_table :studentgroups, :student_in_courses
  end

  def down
    rename_table :student_in_courses, :studentgroups
  end
end
