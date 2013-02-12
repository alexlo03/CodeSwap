class AddHiddenToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :hidden, :boolean
  end
end
