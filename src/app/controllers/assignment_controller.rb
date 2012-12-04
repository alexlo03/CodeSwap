class AssignmentController < ApplicationController

  def index
        
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

end
