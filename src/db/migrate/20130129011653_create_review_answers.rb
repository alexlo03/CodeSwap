class CreateReviewAnswers < ActiveRecord::Migration
  def change
    create_table :review_answers do |t|
      t.text :answer
      t.integer :user_id
      t.integer :review_question_id

      t.timestamps
    end
  end
end
