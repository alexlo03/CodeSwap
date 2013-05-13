class CreateFacultyReviews < ActiveRecord::Migration
  def change
    create_table :faculty_reviews do |t|
      t.integer :review_mapping_id
      t.text :content
      
      t.timestamps
    end
  end
end
