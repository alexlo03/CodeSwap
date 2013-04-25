## Handles faculty views
## Deprecated?
class FacultyController < ApplicationController
include ApplicationHelper

  ## Lists all of the courses the user has access to
  # [Route(s)]
  ## * /courses
  # [Params]
  ## * None
  # [Environment Variables]
  ## * classes - Courses the user has access to (as a student or faculty)
  ## * classes_ta - Courses the user is a ta for.
  def index
		# List all of the courses
    requires({'role'=>['admin', 'faculty', 'student']})
    unless current_user.nil?
      if(current_user.role == 'admin')
        @classes = Course.all
      elsif(current_user.role == 'faculty')
        @classes = Course.find_all_by_user_id(current_user.id)
      else
        @classes = Course.find_all_by_id(StudentInCourse.find_all_by_user_id(current_user.id).collect(&:course_id))
        @classes_ta = Course.find_all_by_id(TaForCourse.find_all_by_user_id(current_user.id).collect(&:course_id))
      end
    end
  end

    
end
