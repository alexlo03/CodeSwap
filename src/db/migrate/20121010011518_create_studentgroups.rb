class CreateStudentgroups < ActiveRecord::Migration
  def change
    create_table :studentgroups do |t|
      t.timestamps
    end
  end
end
