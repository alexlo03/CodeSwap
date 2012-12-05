class AssignmentController < ApplicationController

  def index
		requires("student")
		adtuList = AssignmentDefinitionToUser.where(:user_id => current_user.id)
		pastAssignments = []
		currentAssignments = []
		futureAssignments = []
		adtuList.each do |adtu|
			defID = adtu.assignment_definition_id
			assignmentDefinition = AssignmentDefinition.find(defID)
			assignmentID = assignmentDefinition.assignment_id
			assignment = Assignment.find(assignmentID)
			if(assignment.start_date > Time.now)
				futureAssignments.insert(0,assignment)
			elsif((assignment.start_date <= Time.now) && (Time.now <= assignment.end_date))
				currentAssignments.insert(0,assignment)
			else
				pastAssignments.insert(0,assignment)
			end
		end
		@pastAssignments = pastAssignments
		@futureAssignments = futureAssignments
		@currentAssignments = currentAssignments
		@adtuList = adtuList
  end


  # GET
  def create
    course_id = params[:course_id]
    @course = Course.find_by_id(course_id)
    
  end


  # POST
  def submit_new
    startDate = params[:startDate]
    endDate = params[:endDate]
    name = params[:name]
    description = params[:description]
    course_id = params[:course_id].to_i
    
    startDate = Date.strptime(startDate, '%m-%d-%Y')
    endDate = Date.strptime(endDate, '%m-%d-%Y')


    assignment = Assignment.new
      assignment.start_date = startDate
      assignment.end_date = endDate
      assignment.name = name
      assignment.course_id = course_id
    assignment.save

    definition = AssignmentDefinition.new
      definition.assignment_id = assignment.id
      definition.description = description
    definition.save
    
    students = Studentgroup.where(:course_id => course_id)
    students.each do |student|
      AssignmentDefinitionToUser.new(:assignment_definition_id => definition.id, :user_id => student.user_id).save
    end

    flash[:notice] = 'What a neat assignment.'
  end

	def view
		@id = params[:id]
		@assignment = Assignment.find(@id)
		adtuList = AssignmentDefinitionToUser.where(:user_id => current_user.id)
		@assignmentDefinition = 'hello'
		adtuList.each do |adtu|
			definition = AssignmentDefinition.find(adtu.assignment_definition_id)
			if(definition.assignment_id == @assignment.id)
				@assignmentDefinition = definition
			end
		end
		
	end

	def upload
		#upload = params['upload']
    name =  params['datafile'].original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(params['datafile'].read) }

	end

end
