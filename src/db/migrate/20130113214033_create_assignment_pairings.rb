class CreateAssignmentPairings < ActiveRecord::Migration
  def change
    create_table :assignment_pairings do |t|
      t.integer :assignment_definition_id
      t.integer :seed
      t.integer :previous_id
      t.integer :depth
      t.integer :number_of_graders

      t.timestamps
    end
  end
end
