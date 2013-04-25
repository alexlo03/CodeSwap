# TODO: Email Notifications for Administrators
## Handles Course Views
class CourseController < ApplicationController
include CourseHelper

  ## Displays information about the course
  # [Route(s)]
  ## * /course/show/:c_id
  # [Params]
  ## * c_id - id for the course
  # [Environment Variables]
  ## [course]
  ### * Current course to be viewed
  ## [students]
  ### * List of students in the course
  ## [tas]
  ### * List of tas in the course
  ## [teacher]
  ### * Faculty member for the course
  ## [admin]
  ### * List of all admins
  ## [user_is_student]
  ## [user_is_ta_or_faculty_or_admin]
  ## [group1]
  ### * Users belonging to Group 1 for the course
  ## [group2]
  ### * Users belonging to Group 2 for the course
  ## [assignments]
  ### * All regular assignments for the course
  ## [review_assignments]
  ### * All review assignments for the course
  def show
    id = params[:c_id]
		logger = Logger.new('log/course.log')
		logger.info params.inspect
    @course = Course.find(id)    
    requires({'role' => ['admin','faculty','student'],'course_id' => id})
		#if the course is found & and the user is enrolled in the course, retrieve mappings of students and tas to a course.
    unless (@course.nil? || current_user.nil?)
      @students = StudentInCourse.where(:course_id => id)
      @tas = TaForCourse.where(:course_id => id)
      @teacher = User.where(:id => @course.user_id).first
      @admin = User.where(:role => 'admin')
			#Detect whether user is student or faculty for this given course (can't use roles due to TAs)
      @user_is_student = !@students.find_all_by_user_id(current_user.id).empty?
      @user_is_ta_or_faculty_or_admin = !@tas.find_all_by_user_id(current_user.id).empty? || (current_user.id == @teacher.id unless @teacher.nil?) || (@admin.include?(current_user) unless @admin.nil?)
      if(@user_is_student)
        @assignments = Assignment.where(:course_id => id, :hidden => false)
      else
        @assignments = Assignment.where(:course_id => id)
      end
      
      @group1 = CourseGroup.find_all_by_course_id_and_group(id, 0).collect(&:user_id)
      @group2 = CourseGroup.find_all_by_course_id_and_group(id, 1).collect(&:user_id)
      
			@review_assignments = ReviewAssignment.find_all_by_course_id(id)
    end
  end

  
  ## Populates view with modifiable course information
  # [Route(s)]
  ## * /course/edit/:id
  # [Params]
  ## * id - ID of the course to modify
  # [Environment Variables]
  ## * course - Course being modified
  ## * students - List of students in the course
  ## * tas - List of teaching assistants for the course
  def edit
    #Validate
    id = params[:id]
    @course = Course.find(id)
    requires({'role' => ['admin','faculty'],'course_id' => id})
    if(@course.nil?)
      flash[:error] = 'Something has gone horribly wrong. A system administrator has been contacted.'
    else
      student_ids = StudentInCourse.where(:course_id => id).collect(&:user_id)
      ta_ids = TaForCourse.where(:course_id => id).collect(&:user_id)
      
      @students = User.find_all_by_id(student_ids)
      @tas = User.find_all_by_id(ta_ids)
    end
  end

  ## Updates course information
  # [Route(s)]
  ## * /course/submit_edit/
  # [Params]
  ## * course_id - ID of course being modified
  ## * number - New Course Number of the course
  ## * term - New term of the course
  ## * section - New section of the course
  ## * name - New name of the course
  # [Environment Variables]
  ## * None
  def submit_edit
    id = params[:course_id]
    requires({'role' => ['admin','faculty'],'course_id'=>id})
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
    
    StudentInCourse.delete_all(:course_id => id, :user_id => studentsToRemove)
    TaForCourse.delete_all(:course_id => id, :user_id => tasToRemove)

    flash[:notice] = "Changes saved."
  
  end

  ## Populates a view for creating a new course
  # [Route(s)]
  ## * /course/new
  # [Params]
  ## * None
  # [Environment Variables]
  ## * None
  def new
    requires({'role' => ['admin','faculty']})
  end

  ## Creates a new course with info from /new page
  # [Route(s)]
  ## * /course/create
  # [Params]
  ## * course_name - Name of the course
  ## * course_term - Term of the course
  ## * course_number - Course Number of the course
  ## * students_csv - .csv of the students file
  # [Environment Variables]
  ## * None
  def create
    requires({'role' => ['admin','faculty']})
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

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def add_student
    course_id = params[:course_id]
    requires({'role' => ['admin','faculty'],'course_id'=>course_id})
    first = params[:first]
    last = params[:last]
    email = params[:email]
    role = params[:role]
    
    
    course = Course.find(course_id)

    student = User.find_by_email(email)
    unless student
      student = create_and_invite_user(first, last, email, 'student')
    end

    unless student
      render :text => 'Error adding student.'
    else
      if role == 'student'
        StudentInCourse.create(:user_id => student.id, :course_id => course.id)
        render :text => 'Student added successfully.'
      elsif role == 'ta'
        TaForCourse.create(:user_id => student.id, :course_id => course.id)
        render :text => 'TA added successfully.'
      end
    end
  
  end

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * /course/manage_groups/id
  # [Params]
  ## * (GET) id - ID of the course
  ## * (POST) group1 - List of students in group 1
  ## * (POST) group2 - List of students in group 2
  # [Environment Variables]
  ## * (GET) ungrouped - List of students that do not belong to a group
  ## * (GET) group_1 - List of students belonging to group 1
  ## * (GET) group_2 - List of students belonging to group 2
  ## * (POST) None
  def manage_groups
  
    if request.get?
      course_id = params[:id]
      @course = Course.find(course_id)
      
      group_1 = CourseGroup.find_all_by_course_id_and_group(course_id, 0).collect(&:user_id)
      group_2 = CourseGroup.find_all_by_course_id_and_group(course_id, 1).collect(&:user_id)

      course_students = StudentInCourse.find_all_by_course_id(course_id).collect(&:user_id)
      
      @ungrouped = User.find_all_by_id(course_students).reject{ |user| user.id.in? group_1 or user.id.in? group_2 }
      @group_1 = User.find_all_by_id(group_1)
      @group_2 = User.find_all_by_id(group_2)
    else #post request
      course_id = params[:id]
      group1 = params['group1']
      group2 = params['group2']
      ungrouped = params['ungrouped']
      
      
      
      CourseGroup.destroy_all(:course_id => course_id)
      group1.each do |user|
        CourseGroup.create(:course_id => course_id, :user_id => user, :group => 0)
      end
      group2.each do |user|
        CourseGroup.create(:course_id => course_id, :user_id => user, :group => 1)
      end
      
      render :nothing => true
      flash[:notice] = "Groups updated!"
    end
  end
  

end
