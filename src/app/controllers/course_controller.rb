# TODO: Email Notifications for Administrators
class CourseController < ApplicationController
	
	#Show information about a course
  def show
		#Find the course, then if the course is found, retrieve mappings of students and tas to a course.
    id = params[:id]
    @course = Course.find(id)
    unless @course.nil?
      @students = Studentgroup.where(:course_id => id)
      @tas = Tagroup.where(:course_id => id)
      @teacher = User.where(:id => @course.user_id).first

			#Detect whether user is student or faculty for this given course (can't use roles due to TAs)
      @user_is_student = !@students.find_all_by_user_id(current_user.id).empty?
      @user_is_ta_or_faculty = !@tas.find_all_by_user_id(current_user.id).empty? || (current_user.id == @teacher.id unless @teacher.nil?)
      @assignments = Assignment.where(:course_id => id)
    end
  end

  
  # GET
  def edit
    id = params[:id]
    @course = Course.find(id)
    if(@course.nil?)
      flash[:error] = 'Something has gone horribly wrong. A system administrator has been contacted.'
    else
      student_ids = Studentgroup.where(:course_id => id).collect(&:user_id)
      ta_ids = Tagroup.where(:course_id => id).collect(&:user_id)
      
      @students = User.find_all_by_id(student_ids)
      @tas = User.find_all_by_id(ta_ids)
    end
  end

  # POST
  def submit_edit
    id = params[:course_id]
    course_number = params[:number]
    course_term = params[:term]
    course_name = params[:name]
    course_section = params[:section]

    studentsToRemove = params[:students_to_remove]
    tasToRemove = params[:tas_to_remove]

    course = Course.find(id)
    


    course.course_number = course_number
    course.term = course_term
    course.name = course_name
    course.section = course_section
    course.save
    
    Studentgroup.delete_all(:course_id => id, :user_id => studentsToRemove)
    Tagroup.delete_all(:course_id => id, :user_id => tasToRemove)

    flash[:notice] = "Changes saved."
  
  end 

end
