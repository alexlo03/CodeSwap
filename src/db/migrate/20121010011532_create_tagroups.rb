class CreateTagroups < ActiveRecord::Migration
  def change
    create_table :tagroups do |t|
      t.timestamps
    end
  end
end
