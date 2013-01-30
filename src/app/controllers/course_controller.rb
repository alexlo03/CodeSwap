# TODO: Email Notifications for Administrators
class CourseController < ApplicationController
include ApplicationHelper
include CourseHelper

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
			@review_assignments = ReviewAssignment.find_all_by_course_id(id)
    end
  end

  
  # GET
  def edit
    id = params[:id]
    requiresUsers(['admin','faculty'],id)

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

  def new
    @name = params[:name]
    @term = params[:term]
    @number = params[:number]
    @section = params[:section]
  end

  def create
    course_name = params[:course_name]
    course_term = params[:course_term]
    course_number = params[:course_number]
    course_section = params[:course_section]

    course_exists = !(Course.find_all_by_name_and_course_number_and_section_and_term(course_name, course_number, course_section, course_term).empty?)

    if course_exists
      flash[:error] = 'A course already exists with that information. Please try again with new info or contact a system administrator.'
      redirect_to new_course_path(:name => course_name, :term => course_term, :number => course_number, :section => course_section)
    else
      course = Course.create(:name => course_name, :course_number => course_number, :section => course_section, :term => course_term, :user_id => current_user.id)

      
      course.import_students_and_tas(params[:students_csv])
			course.save
      flash[:notice] = 'Course created successfully!'
      redirect_to show_course_path course.id
    end
  end

  def add_student
    first = params[:first]
    last = params[:last]
    email = params[:email]
    role = params[:role]
    course_id = params[:course_id]
    
    course = Course.find(course_id)

    student = User.find_by_email(email)
    unless student
      student = create_and_invite_user(first, last, email, 'student')
    end

    unless student
      render :text => 'Error adding student.'
    else
      if role == 'student'
        Studentgroup.create(:user_id => student.id, :course_id => course.id)
        render :text => 'Student added successfully.'
      elsif role == 'ta'
        Tagroup.create(:user_id => student.id, :course_id => course.id)
        render :text => 'TA added successfully.'
      end
    end
  
  end

end
