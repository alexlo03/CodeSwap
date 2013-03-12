class RemoveGroupedFromAssignment < ActiveRecord::Migration
  def up
    remove_column :assignments, :grouped
  end

  def down
    add_column :assignments, :grouped, :boolean
  end
end
