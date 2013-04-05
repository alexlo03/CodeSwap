class AddUploadedByToFileSubmission < ActiveRecord::Migration
  def up
    add_column :file_submissions, :uploaded_by, :integer
    FileSubmission.all.each do |fs|
      fs.update_attribute :uploaded_by, fs.user_id
    end
  end
  def down
    remove_column :file_submission, :uploaded_by
  end
end
