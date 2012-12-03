class AddUserIdColumnToStudentGroup < ActiveRecord::Migration
  def change
    add_column :studentgroups, :user_id, :integer
  end
end
