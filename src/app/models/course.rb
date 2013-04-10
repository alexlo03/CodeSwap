class Course < ActiveRecord::Base
  require 'csv'

  belongs_to :user
  has_one :studentgroup
  has_one :tagroup
	has_many :course_groups
  attr_accessible :course_number, :name, :section, :term, :user_id

  # Imports Students / TAs from a spreadsheet
  def import_students_and_tas(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        user = User.find_by_email(row["email"].downcase)
        # Create random password, requires members to respond to email before using the system.
        unless user
          o =[('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
          token = (0...12).map{ o[rand(o.length)] }.join
          user = User.new(:password => token, :password_confirmation => token)
          user.reset_password_token = token
          user.reset_password_sent_at = Time.now
          user.attributes = row.to_hash.slice(*User.accessible_attributes)
          user.role = 'student'
          user.save!
          Emailer.delay.signup_confirmation(user)
        end

        if row["role"].downcase == 'student'
          Studentgroup.create(:user_id =>  user.id, :course_id => id)
					group = row['group']
					unless(group.nil?)
						CourseGroup.create(:user_id => user.id, :course_id => id, :group => group)
					end
        elsif row["role"].downcase == 'ta'
          Tagroup.create(:user_id => user.id, :course_id => id)
        end
      end
  end

  # Fetches students within a course
  def get_students
    Studentgroup.where(:course_id => id).collect(&:user_id)
  end

  def get_tas
    Tagroup.find_all_by_course_id(id).collect(&:user_id)
  end

  def is_user_ta(user_id)
    get_tas.include?(user_id)
  end
  # Opens CSV / Excel files
  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else 
      flash[:error] = "Unknown file type: #{file.original_filename}"
      redirect_to new_course_path
    end
  end

	def get_groups
		group0 = course_groups.find_all_by_group(0).collect(&:user_id)
		group1 = course_groups.find_all_by_group(1).collect(&:user_id)
		[group0,group1]
	end

end
