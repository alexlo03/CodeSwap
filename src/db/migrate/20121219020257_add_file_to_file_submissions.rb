class AddFileToFileSubmissions < ActiveRecord::Migration
  def change
    add_column :file_submissions, :file, :string
  end
end
