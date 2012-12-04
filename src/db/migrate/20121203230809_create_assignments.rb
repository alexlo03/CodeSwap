class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|

      t.string :name, :null => false

      t.datetime :start_date, :null => false
      t.datetime :end_date, :null => false

      t.integer :course_id

      t.timestamps
    end
  end
end
