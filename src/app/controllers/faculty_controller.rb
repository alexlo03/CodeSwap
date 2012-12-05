class FacultyController < ApplicationController

  def index
		# List all of the courses
    requires ['admin', 'faculty']
    @classes = Course.all
  end

  def new_course
		#Create a new Course
    requires ['admin', 'faculty']
    @course = Course.new
  end

  def add_course
    requires ['admin', 'faculty']
		#Get all of the parameters
    cName = params[:cname]
    cTerm = params[:cterm]
    cNumber = params[:cnumber]
    cSection = params[:csection] && params[:csection].to_i

		#Students and Tas is a comma seperated list in form of First Name, Last Name, email,...
    students = params[:students]
    tas = params[:tas]

		#Check to see if a course exists with the same unique values
    count = Course.where(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection).count    
    c = Course.new(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection)

		#Split the student and ta strings, remove whitespace
    students = students.gsub(/\s+/, "").split(",")
    tas = tas.gsub(/\s+/, "").split(",")
    studentCount = ((students.count)/3) - 1
    taCount = ((tas.count)/3) - 1
    if(count == 0 && c.save)
      for i in (0..studentCount)
        studentGroup = Studentgroup.new
        studentGroup.course_id = c.id
        first = students[3*i]
        last = students[3*i + 1]
        email = students[3*i + 2].downcase
				#Check to see if user exists with the same email. If not, create new
        u = User.where(:email => email).first
        if u.nil?
          u = User.new(:email=>email, :first_name => first, :last_name => last)
          u.role = "student"
          u.password ||= "password"
          u.password_confirmation ||="password"
          bool = u.save
        end
				#Save studentGroup (mapping of students to class)
        studentGroup.user_id = u.id
        studentGroup.save  
      end
      unless (tas == "")
        for i in (0..taCount)
          taGroup = Tagroup.new
          taGroup.course_id = c.id
          first = tas[3*i]
          last = tas[3*i + 1]
          email = tas[3*i + 2].downcase
          u = User.where(:email => email).first
					#Check to see if user exists with the same email. If not, create new
          if u.nil?
            u = User.new(:email=>email, :first_name => first, :last_name => last)
            u.role = "student"
            u.password ||= "password"
            u.password_confirmation ||="password"
            bool = u.save
          end
					#Save taGroup (mapping of TAs to class)
          taGroup.user_id = u.id
          taGroup.save 
        end
        c.user_id = current_user.id
        c.save
      end
    else
			#If course exists, raise error, new page is not loaded (yay ajax)
      c["error"] = "Course Already Exists"
    end
    render :json => c.to_json
  end
    
end
