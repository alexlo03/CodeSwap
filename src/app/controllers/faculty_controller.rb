class FacultyController < ApplicationController

  def index
    requires ['admin', 'faculty']
    @classes = Course.all
  end

  def new_course
    requires ['admin', 'faculty']
    @course = Course.new
  end

  def add_course
    requires ['admin', 'faculty']
    cName = params[:cname]
    cTerm = params[:cterm]
    cNumber = params[:cnumber]
    cSection = params[:csection] && params[:csection].to_i
    students = params[:students]
    count = Course.where(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection).count    
    c = Course.new(:name => cName, :term => cTerm, :course_number => cNumber, :section => cSection)
    students = students.gsub(/\s+/, "").split(",")
    studentCount = ((students.count)/3) - 1
    if(count == 0 && c.save)
      for i in (0..studentCount)
        first = students[3*i]
        last = students[3*i + 1]
        email = students[3*i + 2]
        unless User.where(:email => email).count != 0
          u = User.create(:email => email, :first_name => first, :last_name => last, :password => 'student_password',:password_confirmation => 'student_password', :role => 'student')
          c.users << u
        end
      end
      c.save
    else
      c["error"] = "Course Already Exists"
    end
    render :json => c.to_json
  end
    
end
