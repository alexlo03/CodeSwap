class FileSubmissionsController < ApplicationController

  def new
    assignment = Assignment.find(params[:assignment_id])
    
    @submission = FileSubmission.new(:assignment_id => assignment.id)
  end

  def create
    parameters = params[:file_submission]
    assignment = Assignment.find(parameters['assignment_id'])
    definition = AssignmentDefinition.find_by_assignment_id(assignment.id)
    file = parameters['file']

    @submission = FileSubmission.new(:course_id => assignment.course_id, :assignment_id => assignment.id, :assignment_definition_id => definition.id, :user_id => current_user.id, :file => file, :name => file.original_filename)

    @submission.save

    course = Course.find(assignment.course_id)

    @faculty = current_user.id == course.user_id
    @ta = !Tagroup.where(:course_id => course.id, :user_id => current_user.id).empty?
    @student = !Studentgroup.where(:course_id => course.id, :user_id => current_user.id).empty?

    render '/assignment/create.js'
  end

  def delete
    id = params[:file_id]
    submission = FileSubmission.find(id)

    faculty_id = Course.find(Assignment.find(submission.assignment_id).course_id).user_id

    if ((current_user.id == submission.user_id) or (current_user.id == faculty_id))
      File.delete(submission.full_save_path) 
      FileSubmission.destroy(id)
      flash[:notice] = "File removed successfully."
    else
      flash[:error] = "You do not have permission to do that."
    end
    
    redirect_to assignment_view_path(submission.assignment_id)
  end
  

end
