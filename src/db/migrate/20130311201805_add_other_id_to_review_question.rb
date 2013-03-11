class AddOtherIdToReviewQuestion < ActiveRecord::Migration
  def change
		add_column :review_questions, :other_id, :integer
  end
end
