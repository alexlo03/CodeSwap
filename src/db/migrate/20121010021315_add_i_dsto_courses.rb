class AddIDstoCourses < ActiveRecord::Migration
  def change
    add_column :courses, :studentgroup_id, :integer
    add_column :courses, :tagroup_id, :integer
  end
end
