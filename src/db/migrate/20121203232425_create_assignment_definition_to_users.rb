class CreateAssignmentDefinitionToUsers < ActiveRecord::Migration
  def change
    create_table :assignment_definition_to_users do |t|

      t.integer :user_id

      t.integer :assignment_definition_id

      t.timestamps
    end
  end
end
