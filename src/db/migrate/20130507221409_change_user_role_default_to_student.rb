class ChangeUserRoleDefaultToStudent < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, :default => "student"
  end
end
