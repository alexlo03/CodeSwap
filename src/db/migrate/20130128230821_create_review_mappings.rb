class CreateReviewMappings < ActiveRecord::Migration
  def change
    create_table :review_mappings do |t|
      t.integer :user_id
      t.integer :other_user_id
      t.integer :review_assignment_id

      t.timestamps
    end
  end
end
