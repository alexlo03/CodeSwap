## Handles File Submission objects
class FileSubmissionsController < ApplicationController


  ## Creates a new file submission
  # [Route(s)]
  ## * /files/new/:assignment_id
  # [Params]
  ## * assignment_id - ID of the assignment the file belongs to.
  # [Environment Variables]
  ## * submission - The newly instantiated FileSubmission object
  def new
    assignment = Assignment.find(params[:assignment_id])
    
    @submission = FileSubmission.new(:assignment_id => assignment.id)
  end

  ## View contents of the file in the browser
  # [Route(s)]
  ## * /files/view_live/:file_id
  # [Params]
  ## * file_id - ID of the FileSubmission object
  # [Environment Variables]
  ## * contents - Contents of the file
  def view_live
    id = params[:file_id]
    submission = File.read(FileSubmission.find(id).full_save_path)
    @contents = submission.split(/\n/)
  end

  ## Creates a new FileSubmission object
  # [Route(s)]
  ## * /files/create/
  # [Params]
  ## * file_submission - Block of parameters
  ###   1. user_id - id of user to set user_id field to
  ###   2. assignment_id - id of assignment the file is uploaded for
  ###   3. file - file object
  # [Environment Variables]
  ## * submission - newly created filesubmission object
  ## * assignmentFile - true if the file should be uploaded as an assignment file
  ## * studentFile - true if the file should be uploaded as an assignment submission file
  ## * assignment - assignment associated with the file
  def create
    parameters = params[:file_submission]
    assignment = Assignment.find(parameters['assignment_id'])
    definition = AssignmentDefinition.find_by_assignment_id(assignment.id)
    file = parameters['file']
    
    user_id = current_user.id
    unless (not parameters['user_id']) or parameters['user_id'] == ''
      user_id = parameters['user_id']
    end
    
    file.original_filename.gsub!(/[^a-z0-9A-Z.]/, '')

    user = User.find(user_id)
    
    logger = Logger.new("log/uploads.log")

    logger.info "#{assignment.course.id}"
    logger.info "USER ID: #{user_id} CURRENT USER #{current_user.id}"
	  if assignment.course.is_user_student(user_id)
	    user_id = current_user.id if assignment.course.is_user_student(current_user.id)
        logger.info "#{Time.now}:: #{current_user.friendly_full_name} (ID# #{current_user.id}) has submitted something for user with ID# #{user_id}."
		  oldSubmission = FileSubmission.where(:assignment_id => assignment.id,
					  :course_id => assignment.course_id, :user_id => user_id)[0]
		  unless oldSubmission.nil?
			  File.delete(oldSubmission.full_save_path)
			  oldSubmission.destroy
			  logger.info "#{Time.now}::\t #{current_user.friendly_full_name} has just overwritten the old submission."
		  end
	  end

      @submission = FileSubmission.new(:course_id => assignment.course_id, :assignment_id => assignment.id, :assignment_definition_id => definition.id, :user_id => user_id, :file => file, :name => file.original_filename, :uploaded_by => current_user.id)
      @submission.save

    logger.info "#{Time.now}:: #{current_user.friendly_full_name} stored submission successfully at #{@submission.full_save_path}."

      course = Course.find(assignment.course_id)

    @assignmentFile = user_id == course.user_id
    @studentFile = !StudentInCourse.find_all_by_user_id_and_course_id(user_id, course.id).empty?
  
		@assignment = assignment
		
    render '/assignment/create.js'  
  end

  ## Deletes the file matching :file_id
  # [Route(s)]
  ## * /files/delete/:file_id
  # [Params]
  ## * file_id - ID of the file to delete
  # [Environment Variables]
  ## * None
  def delete
    if(current_user)
	user_id = current_user.id

	id = params['file_id']
		submission = FileSubmission.find_by_id(id)
	if(submission)
		logger = Logger.new("log/uploads.log")
		logger.info "#{Time.now}:: #{current_user.friendly_full_name} (ID# #{current_user.id}) has attempted to delete #{submission.name}."

		if(submission && submission.user_can_delete(user_id))
			faculty_id = Course.find(Assignment.find(submission.assignment_id).course_id).user_id

			File.delete(submission.full_save_path)
			FileSubmission.destroy(id)
			flash[:notice] = "File removed successfully."
			logger.info "Delete permitted."
		else
			flash[:error] = "You do not have permission to do that."
			logger.info "Request denied."
		end
		redirect_to assignment_view_path(submission.assignment_id)
	else
		flash[:error] = "File does not exist"
		redirect_to root_path
	end

   else
   flash[:error] = 'You do not have permission to delete this item. Please login.'
   redirect_to root_path
   end
  end
  

end
