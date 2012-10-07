class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :course_number
      t.integer :section
      t.string :term

      t.timestamps
    end
  end
end
