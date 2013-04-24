class RenameTagroupToTaForCourse < ActiveRecord::Migration
  def up
    rename_table :tagroups, :ta_for_courses
  end

  def down
    rename_table :ta_for_courses, :tagroups
  end
end