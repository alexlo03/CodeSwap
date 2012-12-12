class AddCourseidAndAssignmentIdToFileSubmission < ActiveRecord::Migration
  def change
    add_column :file_submissions, :course_id, :integer
    add_column :file_submissions, :assignment_id, :integer
  end
end
