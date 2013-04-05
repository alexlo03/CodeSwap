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
    assignment = Assignment.find(parameters['assignment_id'])
    definition = AssignmentDefinition.find_by_assignment_id(assignment.id)
    file = parameters['file']
    user_id = current_user.id
    user_id = parameters['user_id'] unless parameters['user_id'] == ''
    file.original_filename.gsub!(/[^a-z0-9A-Z.]/, '')

    user = User.find(user_id)
    
	  if user.student? 
	    user_id = current_user.id
		  oldSubmission = FileSubmission.where(:assignment_id => assignment.id,
					  :course_id => assignment.course_id, :user_id => user_id)[0]
		  unless oldSubmission.nil?
			  File.delete(oldSubmission.full_save_path)	
			  oldSubmission.destroy
		  end
	  end


    logger = Logger.new("log/uploads.log")
    logger.info "#{Time.now}:: #{current_user.friendly_full_name} (ID# #{current_user.id}) has submitted something for user with ID# #{user_id}."

      @submission = FileSubmission.new(:course_id => assignment.course_id, :assignment_id => assignment.id, :assignment_definition_id => definition.id, :user_id => user_id, :file => file, :name => file.original_filename, :uploaded_by => current_user.id)
      @submission.save

    logger.info "#{Time.now}:: #{current_user.friendly_full_name} stored submission successfully at #{@submission.full_save_path}."

      course = Course.find(assignment.course_id)

    @faculty = current_user.id == course.user_id
    @ta = !Tagroup.where(:course_id => course.id, :user_id => current_user.id).empty?
    @student = !Studentgroup.where(:course_id => course.id, :user_id => current_user.id).empty?
		
		@assignment = assignment
		
    render '/assignment/create.js'  
  end

  def delete
    id = params[:file_id]
    submission = FileSubmission.find(id)

    faculty_id = Course.find(Assignment.find(submission.assignment_id).course_id).user_id

    logger = Logger.new("log/uploads.log")
    logger.info "#{Time.now}:: #{current_user.friendly_full_name} (ID# #{current_user.id}) has attempted to delete #{name}."

    if ((current_user.id == submission.user_id) or (current_user.id == faculty_id))
      File.delete(submission.full_save_path)
			name = FileSubmission.find(id).name 
      FileSubmission.destroy(id)
      flash[:notice] = "File removed successfully."
      logger.info "Delete permitted."
    else
      flash[:error] = "You do not have permission to do that."
      logger.info "Request denied."
    end
    redirect_to assignment_view_path(submission.assignment_id)
  end
  

end
