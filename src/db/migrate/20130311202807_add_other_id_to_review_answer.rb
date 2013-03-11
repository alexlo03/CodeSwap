class AddOtherIdToReviewAnswer < ActiveRecord::Migration
  def change
		add_column :review_answers, :other_id, :integer
  end
end
