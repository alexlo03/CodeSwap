class AddCourseIdColumnToTagroup < ActiveRecord::Migration
  def change
    add_column :tagroups, :course_id, :integer
  end
end
