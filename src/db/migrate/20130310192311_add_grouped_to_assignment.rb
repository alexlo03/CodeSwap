class AddGroupedToAssignment < ActiveRecord::Migration
  def change
		add_column :assignments,  :grouped, :boolean
  end
end
