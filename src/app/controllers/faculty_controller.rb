class FacultyController < ApplicationController
include ApplicationHelper
  def index
		# List all of the courses
    requires({'role'=>['admin', 'faculty', 'student']})
    unless current_user.nil?
      if(current_user.role == 'admin')
        @classes = Course.all
      elsif(current_user.role == 'faculty')
        @classes = Course.find_all_by_user_id(current_user.id)
      else
        @classes = Course.find_all_by_id(StudentInCourse.find_all_by_user_id(current_user.id).collect(&:course_id))
        @classes_ta = Course.find_all_by_id(TaForCourse.find_all_by_user_id(current_user.id).collect(&:course_id))
      end
    end
  end

  def new_course
		#Create a new Course
    requires({'role'=>['admin', 'faculty']})
    @course = Course.new
  end

  def add_course
    requires({'role'=>['admin', 'faculty']})
		#Get all of the parameters
    cName = params[:cname]
    cTerm = params[:cterm]
    cNumber = params[:cnumber]
    cSection = params[:csection] && params[:csection].to_i

		#Students and Tas is a comma separated list in form of First Name, Last Name, email,...
    students = params[:students]
    tas = params[:tas]

		#Check to see if a course exists with the same unique values
    numCourses = Course.where(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection).count
    course = Course.new(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection)

		#Split the student and ta strings, remove whitespace
    students = students.gsub(/\s+/, "").split(",")
    tas = tas.gsub(/\s+/, "").split(",")
    studentCount = ((students.count)/3) - 1
    taCount = ((tas.count)/3) - 1
    if(numCourses == 0 && course.save)
      for i in (0..studentCount)
        studentGroup = StudentInCourse.new
        studentGroup.course_id = course.id
        first = students[3*i]
        last = students[3*i + 1]
        email = students[3*i + 2].downcase
				#Check to see if user exists with the same email. If not, create new
        user = User.find_by_email(email)
        if user.nil?
          user = User.new(:email=>email, :first_name => first, :last_name => last)
          user.role = "student"
          user.password ||= "password"
          user.password_confirmation ||="password"
          user.save
        end
				#Save studentGroup (mapping of students to class)
        studentGroup.user_id = user.id
        studentGroup.save  
      end
      unless (tas == "")
        for i in (0..taCount)
          taGroup = TaForCourse.new
          taGroup.course_id = course.id
          first = tas[3*i]
          last = tas[3*i + 1]
          email = tas[3*i + 2].downcase
          user = User.find_by_email(email)
					#Check to see if user exists with the same email. If not, create new
          if user.nil?
            user = User.new(:email=>email, :first_name => first, :last_name => last)
            user.role = "student"
            user.password ||= "password"
            user.password_confirmation ||="password"
            user.save
          end
					#Save taGroup (mapping of TAs to class)
          taGroup.user_id = user.id
          taGroup.save 
        end
        course.user_id = current_user.id
        course.save
      end
    else
			#If course exists, raise error, new page is not loaded (yay ajax)
      course["error"] = "Course Already Exists"
    end
    render :json => course.to_json
  end
    
end
