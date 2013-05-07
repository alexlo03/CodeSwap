class Course < ActiveRecord::Base
  require 'csv'

  belongs_to :user
  has_one :student_in_course
  has_one :ta_for_course
	has_many :course_groups
  attr_accessible :course_number, :name, :section, :term, :user_id

  # Imports Students / TAs from a spreadsheet
	# [Input]
	## * file -- a file in CSV format that contains the following information (with headers)
	##     1. first_name
	##     2. last_name
	##     3. email
	##     4. role (student,ta)
	##     5. group (1,2)
	# [Note]
	## * Creates accounts for users that were not in the database, sends them a registration email
	## * Groups should be even in size (if possible)
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
          StudentInCourse.create(:user_id =>  user.id, :course_id => id)
					group = row['group']
					unless(group.nil?)
						CourseGroup.create(:user_id => user.id, :course_id => id, :group => group)
					end
        elsif row["role"].downcase == 'ta'
          TaForCourse.create(:user_id => user.id, :course_id => id)
        end
      end
  end

  # Fetches students within a course
	# [Return]
	## * Array of user_ids
  def get_students
    StudentInCourse.where(:course_id => id).collect(&:user_id)
  end


  # Fetches teaching assistants within a course
	# [Return]
	## * Array of user_id
  def get_tas
    TaForCourse.find_all_by_course_id(id).collect(&:user_id)
  end
	
	# Checks if a user is a TA for the course
	# [Input]
	## * user_id -- user_id to check
	# [Return]
	## * True if the user is a ta, false otherwise
  def is_user_ta(user_id)
    get_tas.include?(user_id)
  end
    
  def is_user_student(user_id)
    get_students.include?(user_id)
  end

  # Helper used to open CSV / Excel files
	# [Input]
	## * file -- file to be opened
	# [Return]
	## * Readable file object if the file is a csv, xls, or xlsx, redirects otherwise
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

  # Get the different student groups (group 1 and 2)
	# [Return]
	## * 2D array of user_ids
	def get_groups
		group0 = course_groups.find_all_by_group(0).collect(&:user_id)
		group1 = course_groups.find_all_by_group(1).collect(&:user_id)
		[group0,group1]
	end

end
