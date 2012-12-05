class CourseController < ApplicationController

  def show
    id = params[:id]
    @course = Course.find(id)
    unless @course.nil?
      @students = Studentgroup.where(:course_id => id)
      @tas = Tagroup.where(:course_id => id)
      @teacher = User.where(:id => @course.user_id).first
      @user_is_student = !@students.find_all_by_user_id(current_user.id).empty?
      @user_is_ta_or_faculty = !@tas.find_all_by_user_id(current_user.id).empty? || (current_user.id == @teacher.id unless @teacher.nil?)
      @assignments = Assignment.where(:course_id => id)
    end
  end
end
