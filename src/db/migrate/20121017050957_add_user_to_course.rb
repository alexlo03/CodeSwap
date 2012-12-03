class AddUserToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :user_id, :integer
  end
end
