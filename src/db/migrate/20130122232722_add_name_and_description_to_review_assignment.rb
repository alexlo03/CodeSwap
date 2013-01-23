class AddNameAndDescriptionToReviewAssignment < ActiveRecord::Migration
  def change
		add_column :review_assignments, :name, :string
		add_column :review_assignments, :description, :string
		rename_column :review_assignments, :assignment_definition_id, :assignment_id
  end
end
