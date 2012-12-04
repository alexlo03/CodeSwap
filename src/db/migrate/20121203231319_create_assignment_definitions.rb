class CreateAssignmentDefinitions < ActiveRecord::Migration
  def change
    create_table :assignment_definitions do |t|

      t.integer :assignment_id
      
      t.string :description

      t.timestamps
    end
  end
end
