module CourseHelper
  def requiresUsers(roles, course_id)
    unless current_user && roles.include?(current_user.role) && Course.find_all_by_user_id(current_user.id).include?(Course.find_by_id(course_id))
    flash[:error] = 'You do not have permission to view this page. Contact a system administrator if you think this is incorrect.'
      redirect_to root_path
    end
  end
end
