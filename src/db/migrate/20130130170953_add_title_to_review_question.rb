class AddTitleToReviewQuestion < ActiveRecord::Migration
  def up
    add_column :review_questions, :question_title, :string
  end

  def down
    remove_column :review_questions, :question_title
  end
end
