class AdminController < ApplicationController
  def index
    @students = User.find_all_by_role("student")
    @admins = User.find_all_by_role('admin')
    @faculty = User.find_all_by_role('faculty')
    @tas = User.find_all_by_role('ta')
  end

  def create_faculty
    @faculty = User.new
  end

  def confirm_faculty
    u = User.new
    u.email = params[:facultyemail]
    u.password = 'password'
    u.role = 'faculty'
    u.save(:validate => false)
    @new_faculty = User.find_by_email(u.email)
    flash[:notice] = "Faculty Created successfully!"
  end

end
