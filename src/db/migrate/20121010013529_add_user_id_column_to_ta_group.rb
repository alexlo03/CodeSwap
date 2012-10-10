class AddUserIdColumnToTaGroup < ActiveRecord::Migration
  def change
    add_column :tagroups, :user_id, :integer
  end
end
