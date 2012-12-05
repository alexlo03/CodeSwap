class CreateFileSubmissions < ActiveRecord::Migration
  def change
    create_table :file_submissions do |t|
      t.string :name
      t.integer :user_id
      t.integer :assignment_definition_id
      t.timestamps
    end
  end
end
