class AssignmentController < ApplicationController
include AssignmentHelper
  def index
		requires({'role'=>['admin', 'faculty','student']}) # Validation of login and roles
    unless(current_user.nil?)
	    studentAssignments = []
	    studentReviewAssignments = []
	    
      taAssignments = []
      taReviewAssignments = []
      
	    facultyAssignments = []
		  facultyReviewAssignments = []
		  
      allAssignments = []
      allReviewAssignments = []
      if current_user.student?
        studentCourses = Studentgroup.find_all_by_user_id(current_user.id).collect(&:course_id)
        studentAssignments = Assignment.find_all_by_course_id(studentCourses)
			  studentReviewAssignments = ReviewAssignment.find_all_by_course_id(studentCourses)
			  
        taCourseIds = Tagroup.find_all_by_user_id(current_user.id).collect(&:course_id)
        taAssignments = Assignment.find_all_by_course_id(taCourseIds)
        taReviewAssignments = ReviewAssignment.find_all_by_course_id(taCourseIds)
	    elsif current_user.faculty?
        facultyCourses = Course.find_all_by_user_id(current_user.id).collect(&:id)
        facultyAssignments = Assignment.find_all_by_course_id(facultyCourses)
			  facultyReviewAssignments = ReviewAssignment.find_all_by_course_id(facultyCourses)
      elsif current_user.admin?
        allAssignments = Assignment.all
        allReviewAssignments = ReviewAssignment.all
      end
      @studentAssignments = studentAssignments
      @studentReviewAssignments = studentReviewAssignments
      
      @facultyAssignments = facultyAssignments
		  @facultyReviewAssignments = facultyReviewAssignments
		  
		  @taAssignments = taAssignments
		  @taReviewAssignments = taReviewAssignments
		  
		  @allAssignments = allAssignments
		  @allReviewAssignments = allReviewAssignments
    end
  end


  # Get course id for creating an assignment
  def create
    course_id = params[:course_id]
    #Validate
    requires({'role'=>['admin', 'faculty'], 'course_id'=>course_id})
    if current_user
      @course = Course.find_by_id(course_id)
    end
  end

  # Get data for editing an assignment
  def edit
    assignment_id = params[:assignment_id]
    @assignment = Assignment.find_by_id(assignment_id)
    @course = Course.find_by_id(@assignment.course_id)
    requires({'role'=>['admin', 'faculty'], 'course_id' =>@course.id})
    if current_user
      @assignmentDefinition = AssignmentDefinition.find_by_assignment_id(assignment_id)
    end
  end

  # POST
  def submit_new
    unless(current_user.nil?)
      course_id = params[:course_id].to_i
      #Validate
      requires({'role'=>['admin', 'faculty'],'course_id'=>course_id})
		  #Get values from the parameters
      startDate = params[:startDate]
      endDate = params[:endDate]
      startTime = params[:startTime]
      endTime = params[:endTime]
      name = params[:name]
      description = params[:description]
      hidden = params[:hidden]
			hidden = (hidden == 'true')
      

		  #Convert strings to Date objects using format MM/DD/YYYY
			zone = Time.now.zone
      startDate = DateTime.strptime("#{startDate} #{startTime} #{zone}", '%m-%d-%Y %H:%M %p %Z')
      endDate = DateTime.strptime("#{endDate} #{endTime} #{zone}", '%m-%d-%Y %H:%M %p %Z')

		  #Create a new assignment with startDate, endDate, name, and courseID
      assignment = Assignment.new
        assignment.start_date = startDate
        assignment.end_date = endDate
        assignment.name = name
        assignment.course_id = course_id
        assignment.hidden = hidden
      assignment.save
		
		  #Create a new Assignment_Definition with the description given
		  #TODO: Allow multiple definitions per assignment
      definition = AssignmentDefinition.new
        definition.assignment_id = assignment.id
        definition.description = description
      definition.save
      
		  #Create mappings of students to assignment_definition
      students = Studentgroup.where(:course_id => course_id)
      students.each do |student|
        AssignmentDefinitionToUser.new(:assignment_definition_id => definition.id, :user_id => student.user_id).save
      end

      flash[:notice] = 'What a neat assignment.'
    end
  end


  # POST
  def submitchanges
   
    assignment_id = params[:assignment_id].to_i
    assignment = Assignment.find(assignment_id)
    course = Course.find(assignment.course_id)
    #Validate
    requires({'role'=>['admin', 'faculty'],'course_id'=>course.id})
    if current_user
		  #Get values from the parameters
      startDate = params[:startDate]
      endDate = params[:endDate]
      name = params[:name]
      description = params[:description]
      hidden = params[:hidden]
      startTime = params[:startTime]
      endTime = params[:endTime]			
			hidden = (hidden == 'true')

		  #Convert strings to Date objects using format MM/DD/YYYY
			zone = Time.now.zone
      startDate = DateTime.strptime("#{startDate} #{startTime} #{zone}", '%m-%d-%Y %H:%M %p %Z')
      endDate = DateTime.strptime("#{endDate} #{endTime} #{zone}", '%m-%d-%Y %H:%M %p %Z')

		  #Create a new assignment with startDate, endDate, name, and courseID
      
        assignment.start_date = startDate
        assignment.end_date = endDate
        assignment.name = name
        assignment.hidden = hidden
      assignment.save
		
		  #Create a new Assignment_Definition with the description given
		  #TODO: Allow multiple definitions per assignment
      definition = AssignmentDefinition.find_by_assignment_id(assignment_id)
        definition.description = description
      definition.save
      
      flash[:notice] = 'Those changes are GRRRREAT!  Like Frosted Flakes.'
    end
  end

	# Route: /assignment/view/:id
	# Params: id
	# Environment variables: 
	## assignment - current assignment
	## assignmentDefinition - definition of assignment
	## assignmentFiles - List of files submitted by faculty member for this assignment
	## courseStudents - List of all students in the assignment's course
	### Empty if current user is a student
	## faculty - returns whether current user is the faculty member
	## ta - returns whether the current user is a ta for the assignment's course
	## student - returns whether the current user is a student for this course
	## unsubmitted_students - List of students that have no submission linked to them
	## files - List of files visible to current user
	### If Student: Only their files are in this list
	### If Otherwise: All student submissions are in this list
	## id - ID of the current assignment
  def view
    
    id = params[:assignment_id]
    @assignment = Assignment.find(id)
    @assignmentDefinition = AssignmentDefinition.find_by_assignment_id(id)
    
    course = Course.find(@assignment.course_id)
    requires({'role'=>['admin', 'faculty','student'], 'course_id'=>course.id})
    if(current_user)
    
      @assignmentFiles = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => course.user_id)
      courseStudentIds = Studentgroup.find_all_by_course_id(course.id).collect(&:user_id)
    
      @faculty = current_user.id == course.user_id
      @ta = !Tagroup.where(:course_id => course.id, :user_id => current_user.id).empty?
      @student = !Studentgroup.where(:course_id => course.id, :user_id => current_user.id).empty?
	
      @unsubmitted_students = []
      @courseStudents = []
      if @faculty or @ta or current_user.admin?
        @files = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => courseStudentIds)
        @unsubmitted_students = User.find_all_by_id(courseStudentIds.drop_while{|s| s.in? @files.collect(&:user_id)})
        @courseStudents = User.find_all_by_id(courseStudentIds)
        @courseStudents.unshift(User.find(course.user_id))
      elsif @student
        @files = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => current_user.id)
      end
     @id = id
    end
  end

	def adminView
    requires ({'role'=>'admin'})
    if(current_user)
  		assignment_id = params[:assignment_id]
	  	@assignment = Assignment.find(assignment_id)
	  	@fileSubmissions = FileSubmission.where(:assignment_id => assignment_id)
	  end
  end

	def download
		unless(current_user.nil?)
		        file_id = params[:file_id]
		        file = FileSubmission.find_by_id(file_id)

		        if(file.nil? || (not file.user_can_download(current_user.id)))
              name = "Somebody"
              name = current_user.friendly_full_name if current_user
              logger = Logger.new "log/download.log"
              logger.info "#{name} attempted to download a file with id:  #{file_id}"
              redirect_to :root
              flash[:error] = "Either the file you have requested does not exist, or you do not have permission to access file.  Please use the 'Contact Us' form if you believe this is an error."
              
		        else
                	  send_file File.join(file.save_directory, file.name)
		        end
		else
 
      redirect_to "/users/sign_in"
      flash[:error] = "Please Sign-in"
    end

	end

	def downloadAll
	  assignment_id = params[:assignment_id]
    assignment = Assignment.find(assignment_id)
    unless(current_user.nil? || assignment.nil? || (not assignment.user_can_download_all(current_user.id)))

	    require 'zip/zip'
    	require 'zip/zipfilesystem'

		  course_id = assignment.course_id
		  faculty = User.find(current_user.id)
		  dir = 'Uploads/Assignments/Course ID' + course_id.to_s + '/Assignment ID' + assignment.id.to_s
		  archive = File.join(dir,File.basename(dir))+'.zip'
    	FileUtils.rm archive, :force=>true

		  facultySubmissions = assignment.getFacultyFileSubmissions
		  facultySubmissions.collect! {|file| file.full_save_path}

    	Zip::ZipFile.open(archive, 'w') do |zipfile|
      	Dir["#{dir}/**/**"].reject{|f|f==archive}.reject{|f| facultySubmissions.include? f}.reject{|f| f == "#{dir}/#{faculty.username}"}.each do |file|
     	   		zipfile.add(file.sub(dir+'/',''),file)
     		end
    	end
		
		  send_file archive

    else
      name = "Somebody"
      name = current_user.friendly_full_name if current_user
      logger = Logger.new "log/download.log"
      logger.info "#{name} attempted to download all files from an assignment with id:  #{assignment_id}"
      redirect_to :root
      flash[:error] = "Either the files you have requested does not exist, or you do not have permission to access  file.  Please use the 'Contact Us' form if you believe this is an error."
	  end
  end
end
