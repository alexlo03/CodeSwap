class CreateReviewQuestions < ActiveRecord::Migration
  def change
    create_table :review_questions do |t|
      t.text :content
      t.integer :type
			t.integer :review_assignment_id
      t.timestamps
    end
  end
end
