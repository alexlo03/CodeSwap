module CourseHelper
  def requiresCourse(course_id)
    unless Course.find_all_by_user_id(current_user.id).include?(Course.find_by_id(course_id))
    flash[:error] = 'You do not have permission to edit this assignment. Contact a system administrator if you think this is incorrect.'
      redirect_to '/courses'
    end
  end
end
