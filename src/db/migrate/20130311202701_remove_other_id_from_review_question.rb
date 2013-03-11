class RemoveOtherIdFromReviewQuestion < ActiveRecord::Migration
  def up
		remove_column :review_questions, :other_id
  end

  def down
  end
end
