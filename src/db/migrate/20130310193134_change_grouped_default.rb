class ChangeGroupedDefault < ActiveRecord::Migration
  def up
		change_column :assignments, :grouped, :boolean, :default => false
  end

  def down
		change_column :assignments, :grouped, :boolean, :default => nil
  end
end
