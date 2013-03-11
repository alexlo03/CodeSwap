class CreateCourseGroups < ActiveRecord::Migration
  def change
    create_table :course_groups do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :group

      t.timestamps
    end
  end
end
