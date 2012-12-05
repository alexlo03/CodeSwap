class AssignmentController < ApplicationController

  def index
		requires ['admin', 'student', 'faculty'] #Validation of login and roles
    studentAssignmentList = AssignmentDefinitionToUser.where(:user_id => current_user.id) #Get the mappings of Users to Assignment_Definitions
	  pastAssignments = []
	  currentAssignments = []
	  futureAssignments = []
	  studentAssignmentList.each do |adtu|
			#Get the ID of the Assignment_Definition, then find it
		  defID = adtu.assignment_definition_id 
		  assignmentDefinition = AssignmentDefinition.find(defID) 

			#Get the ID of the Assignment, then find it
		  assignmentID = assignmentDefinition.assignment_id
		  assignment = Assignment.find(assignmentID)

			#Sort Assignments by dates (past, current, and future)
		  if(assignment.start_date > Time.now)
			  futureAssignments.insert(0,assignment)
		  elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
			  currentAssignments.insert(0,assignment)
		  else
			  pastAssignments.insert(0,assignment)
		  end
	  end
=begin
    ## TODO: Add a separate TA list and distinguish the two on the view page.
    taCourseIds = Tagroup.find_all_by_user_id(current_user.id).collect(&:course_id)
    taAssignments = Assignment.where(taCourseIds.include? :course_id)
    
    taAssignments.each do |assignment|
		  if(assignment.start_date > Time.now)
			  futureAssignments.insert(0,assignment)
		  elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
			  currentAssignments.insert(0,assignment)
		  else
			  pastAssignments.insert(0,assignment)
		  end
    end

    facultyCourses = Course.find_all_by_user_id(current_user.id).collect(&:id)
    facultyAssignments = Assignment.where(facultyCourses.include? :course_id)

    facultyAssignments.each do |assignment|
		  if(assignment.start_date > Time.now)
			  futureAssignments.insert(0,assignment)
		  elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
			  currentAssignments.insert(0,assignment)
		  else
			  pastAssignments.insert(0,assignment)
		  end
    end

=end
		#Set global varibles for use in the view
	  @pastAssignments = pastAssignments
	  @futureAssignments = futureAssignments
	  @currentAssignments = currentAssignments
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

		#TODO: change directory to be task specific and stores into 'courseid/assignmentid/userid/'
    directory = 'public/data'
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, 'wb') { |f| f.write(params['datafile'].read) }
    
    # fetches assignment definition id from view
    id = params['assignment_definition_id']
    
    # creates and saves a new file submission within the database
    submission = FileSubmission.new
      submission.assignment_definition_id = id
      submission.name = name
      submission.user_id = current_user.id
    submission.save
    flash[:notice] = "Cool file man...that's WICKED!...so raaaad..."
    redirect_to '/assignment/index'

	end

end