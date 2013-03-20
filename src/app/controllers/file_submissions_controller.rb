class FileSubmissionsController < ApplicationController

  def new
    assignment = Assignment.find(params[:assignment_id])
    
    @submission = FileSubmission.new(:assignment_id => assignment.id)
  end

  def view_live
    id = params[:file_id]
    submission = File.read(FileSubmission.find(id).full_save_path)

    @contents = submission.split(/\n/)
    
  end

  def create
    parameters = params[:file_submission]
    @assignment = Assignment.find(parameters['assignment_id'])
    definition = AssignmentDefinition.find_by_assignment_id(assignment.id)
    file = parameters['file']

    file.original_filename.gsub!(/[^a-z0-9A-Z.]/, '')

    
	  if current_user.student? 
		  oldSubmission = FileSubmission.where(:assignment_id => assignment.id,
					  :course_id => assignment.course_id, :user_id => current_user.id)[0]
		  unless oldSubmission.nil?
			  File.delete(oldSubmission.full_save_path)	
			  oldSubmission.destroy
		  end
	  end

      @submission = FileSubmission.new(:course_id => assignment.course_id, :assignment_id => assignment.id, :assignment_definition_id => definition.id, :user_id => current_user.id, :file => file, :name => file.original_filename)
      @submission.save

      course = Course.find(assignment.course_id)

    logger = Logger.new("log/uploads.log")
    logger.info "Student #{current_user.id} #{current_user.friendly_full_name} has submitted #{@submission.name}."
    

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
			name = FileSubmission.find(id).name 
      FileSubmission.destroy(id)
      flash[:notice] = "File removed successfully."
    else
      flash[:error] = "You do not have permission to do that."
    end
    logger = Logger.new("log/uploads.log")
    logger.info "Student #{current_user.id} #{current_user.friendly_full_name} has deleted #{name}."    
    redirect_to assignment_view_path(submission.assignment_id)
  end
  

end
