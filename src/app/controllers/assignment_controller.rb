class AssignmentController < ApplicationController

  def index
		requires ['admin', 'student', 'faculty'] # Validation of login and roles

	  pastAssignments = []
	  currentAssignments = []
	  futureAssignments = []

    taCurrentAssignments = []
    taFutureAssignments = []
    taPastAssignments = []


    if current_user.student?

      # Gathers Student's Assignments based on the AssignmentDefinitionToUser table
  
      studentAssignmentDefinitionIds = AssignmentDefinitionToUser.find_all_by_user_id(current_user.id).collect(&:assignment_definition_id)
      studentAssignmentIDs = AssignmentDefinition.find_all_by_id(studentAssignmentDefinitionIds).collect(&:assignment_id)
      studentAssignments = Assignment.find_all_by_id(studentAssignmentIDs)


      studentAssignments.each do |assignment|
		    if(assignment.start_date > Time.now)
			    futureAssignments.insert(0,assignment)
		    elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
			    currentAssignments.insert(0,assignment)
		    else
			    pastAssignments.insert(0,assignment)
		    end
      end

      taCourseIds = Tagroup.find_all_by_user_id(current_user.id).collect(&:course_id)
      taAssignments = Assignment.where(:course_id => taCourseIds)
      
      taAssignments.each do |assignment|
	      if(assignment.start_date > Time.now)
		      taFutureAssignments.insert(0,assignment)
	      elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
		      taCurrentAssignments.insert(0,assignment)
	      else
		      taPastAssignments.insert(0,assignment)
	      end
      end

	  else
      facultyCourses = Course.find_all_by_user_id(current_user.id).collect(&:id)
      facultyAssignments = Assignment.where(:course_id => facultyCourses)

      facultyAssignments.each do |assignment|
		    if(assignment.start_date > Time.now)
			    futureAssignments.insert(0,assignment)
		    elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
			    currentAssignments.insert(0,assignment)
		    else
			    pastAssignments.insert(0,assignment)
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
  end


  # GET
  def create
    course_id = params[:course_id]
    @course = Course.find_by_id(course_id)
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


	#Populate varibles for use in the view
	def view
		@id = params[:id]
		@assignment = Assignment.find(@id)
    @assignmentDefinition = AssignmentDefinition.find_by_assignment_id(@id)
	end

	def upload
		#params['datafile'] is a File object stored in the system tmp directories
    name =  params['datafile'].original_filename

    assignment_definition_id = params['assignment_definition_id']
    assignment_id = AssignmentDefinition.find(assignment_definition_id).assignment_id
    course_id = Assignment.find(assignment_id).course_id

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
    

    flash[:notice] = "File Submitted Successfully! Well done! A++!"
    redirect_to '/assignment/index'

	end

end
