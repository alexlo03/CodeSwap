class AddGroupedToReviewAssignment < ActiveRecord::Migration
  def change
    add_column :review_assignments, :grouped, :boolean
  end
end
