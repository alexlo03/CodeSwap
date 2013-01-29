class RenameColumnType < ActiveRecord::Migration
  def up
		rename_column :review_questions, :type, :question_type
  end

  def down
  end
end
