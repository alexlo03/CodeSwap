class CreateReviewAssignments < ActiveRecord::Migration
  def change
    create_table :review_assignments do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :user_id
      t.integer :course_id
      t.integer :assignment_definition_id
      t.integer :assignment_pairing_id

      t.timestamps
    end
  end
end
