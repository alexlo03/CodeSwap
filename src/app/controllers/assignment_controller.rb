class AssignmentController < ApplicationController

  def index
		requires ['admin', 'student', 'faculty'] # Validation of login and roles

	  pastAssignments = []
	  currentAssignments = []
	  futureAssignments = []
		reviewAssignments = []
		
    taCurrentAssignments = []
    taFutureAssignments = []
    taPastAssignments = []


    if current_user.student?

      # Gathers Student's Assignments based on the AssignmentDefinitionToUser table
  
      studentAssignmentDefinitionIds = AssignmentDefinitionToUser.find_all_by_user_id(current_user.id).collect(&:assignment_definition_id)
      studentAssignmentIDs = AssignmentDefinition.find_all_by_id(studentAssignmentDefinitionIds).collect(&:assignment_id)
      studentAssignments = Assignment.find_all_by_id(studentAssignmentIDs)
			reviewAssignments = ReviewAssignment.find_all_by_assignment_id(studentAssignmentIDs)

      studentAssignments.each do |assignment|
		    if assignment.has_not_started
			    futureAssignments.unshift assignment
		    elsif assignment.is_active
			    currentAssignments.unshift assignment
		    else
			    pastAssignments.unshift assignment
		    end
      end

      taCourseIds = Tagroup.find_all_by_user_id(current_user.id).collect(&:course_id)
      taAssignments = Assignment.where(:course_id => taCourseIds)
      
      taAssignments.each do |assignment|
	      if assignment.has_not_started
		      taFutureAssignments.unshift assignment
	      elsif assignment.is_active
		      taCurrentAssignments.unshift assignment
	      else
		      taPastAssignments.unshift assignment
	      end
      end

	  else
      facultyCourses = Course.find_all_by_user_id(current_user.id).collect(&:id)
      facultyAssignments = Assignment.where(:course_id => facultyCourses)
			reviewAssignments = ReviewAssignment.where(:course_id => facultyCourses)

      facultyAssignments.each do |assignment|
		    if assignment.has_not_started 
			    futureAssignments.unshift assignment
		    elsif assignment.is_active
			    currentAssignments.unshift assignment
		    else
			    pastAssignments.unshift assignment
		    end
      end
    end

		#Set global varibles for use in the view
	  @pastAssignments = pastAssignments
	  @futureAssignments = futureAssignments
	  @currentAssignments = currentAssignments

    @taPastAssignments = taPastAssignments
    @taFutureAssignments = taFutureAssignments
    @taCurrentAssignments = taCurrentAssignments

		@reviewAssignments = reviewAssignments
  end


  # Get course id for creating an assignment
  def create
    course_id = params[:course_id]
    @course = Course.find_by_id(course_id)
    
  end

  # Get data for editing an assignment
  def edit
    assignment_id = params[:assignment_id]
    @assignment = Assignment.find_by_id(assignment_id)
    @course = Course.find_by_id(@assignment.course_id)
    @assignmentDefinition = AssignmentDefinition.find_by_assignment_id(assignment_id)
  end

  # POST
  def submit_new
		#Get values from the parameters
    startDate = params[:startDate]
    endDate = params[:endDate]
    name = params[:name]
    description = params[:description]
    course_id = params[:course_id].to_i
    

		#Convert strings to Date objects using format MM/DD/YYYY
    startDate = Date.strptime(startDate, '%m-%d-%Y')
    endDate = Date.strptime(endDate, '%m-%d-%Y')

		#Create a new assignment with startDate, endDate, name, and courseID
    assignment = Assignment.new
      assignment.start_date = startDate
      assignment.end_date = endDate
      assignment.name = name
      assignment.course_id = course_id
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



  # POST
  def submitchanges
		#Get values from the parameters
    startDate = params[:startDate]
    endDate = params[:endDate]
    name = params[:name]
    description = params[:description]
    assignment_id = params[:assignment_id].to_i
    

		#Convert strings to Date objects using format MM/DD/YYYY
    startDate = Date.strptime(startDate, '%m-%d-%Y')
    endDate = Date.strptime(endDate, '%m-%d-%Y')

		#Create a new assignment with startDate, endDate, name, and courseID
    assignment = Assignment.find(assignment_id)
      assignment.start_date = startDate
      assignment.end_date = endDate
      assignment.name = name
    assignment.save
		
		#Create a new Assignment_Definition with the description given
		#TODO: Allow multiple definitions per assignment
    definition = AssignmentDefinition.find_by_assignment_id(assignment_id)
      definition.description = description
    definition.save
    
    flash[:notice] = 'Those changes are GRRRREAT!  Like Frosted Flakes.'
  end





	#Populate varibles for use in the view
	def view
		id = params[:assignment_id]
		@assignment = Assignment.find(id)
    @assignmentDefinition = AssignmentDefinition.find_by_assignment_id(id)
		#Get previous submissions

    course = Course.find(@assignment.course_id)
    @assignmentFiles = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => course.user_id)
    
    courseStudentIds = Studentgroup.find_all_by_course_id(course.id).collect(&:user_id)

    @faculty = current_user.id == course.user_id
    @ta = !Tagroup.where(:course_id => course.id, :user_id => current_user.id).empty?
    @student = !Studentgroup.where(:course_id => course.id, :user_id => current_user.id).empty?
	
    if @faculty or @ta
      @files = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => courseStudentIds)
    elsif @student
      @files = FileSubmission.where(:assignment_definition_id => @assignmentDefinition.id, :user_id => current_user.id)
    end
		@id = id

  end


  #NOTE: Out of date, probably safe to remove. 
	def upload
		# params['datafile'] is a File object stored in the system tmp directories
    name =  params['datafile'].original_filename

    assignment_definition_id = params['assignment_definition_id']
    assignment_id = AssignmentDefinition.find(assignment_definition_id).assignment_id
    course_id = Assignment.find(assignment_id).course_id


		if current_user.student? 
			oldSubmission = FileSubmission.where(:assignment_id => assignment_id,
						:course_id => course_id, :user_id => current_user.id)[0]
			unless oldSubmission.nil?
				File.delete(oldSubmission.full_save_path)	
				oldSubmission.destroy
			end
		end

    # creates and saves a new file submission within the database
    submission = FileSubmission.new
      submission.name = name
      submission.user_id = current_user.id
      submission.course_id = course_id
      submission.assignment_id = assignment_id
      submission.assignment_definition_id = assignment_definition_id
    submission.save
		

    FileUtils.mkpath(submission.save_directory)
    path = File.join(submission.save_directory, name)
    File.open(path, 'wb') { |f| f.write(params['datafile'].read) }
    

    flash[:notice] = "File Submitted Successfully! Well done! A++!" + submission.save_directory
    redirect_to '/assignment/index'

	end

	def adminView
		assignment_id = params[:assignment_id]
		@assignment = Assignment.find(assignment_id)
		@fileSubmissions = FileSubmission.where(:assignment_id => assignment_id)
	end

	def download
		file_id = params[:file_id]
		file = FileSubmission.find(file_id)
		send_file File.join(file.save_directory, file.name)
	end

	def downloadAll
	  require 'zip/zip'
  	require 'zip/zipfilesystem'
		assignment_id = params[:assignment_id]
		assignment = Assignment.find(assignment_id)
		course_id = assignment.course_id
		faculty = User.find(current_user.id)
		dir = 'Uploads/Assignments/Course ID' + course_id.to_s + '/Assignment ID' + assignment.id.to_s
		archive = File.join(dir,File.basename(dir))+'.zip'
  	FileUtils.rm archive, :force=>true
		logger = Logger.new("logfile.log")
		logger.info archive
		facultySubmissions = assignment.getFacultyFileSubmissions
		logger.info "**NEW**"
		facultySubmissions.collect! {|file| file.full_save_path}
  	Zip::ZipFile.open(archive, 'w') do |zipfile|
    	Dir["#{dir}/**/**"].reject{|f|f==archive}.reject{|f| facultySubmissions.include? f}.reject{|f| f == "#{dir}/#{faculty.username}"}.each do |file|
					logger.info file
   	   		zipfile.add(file.sub(dir+'/',''),file)
   		end
  	end
		
		send_file archive
	end


end
