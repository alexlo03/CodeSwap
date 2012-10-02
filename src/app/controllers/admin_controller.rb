class AdminController < ApplicationController
  
  def index
    requires ['admin']
    @students = User.find_all_by_role(:student)
    @admins = User.find_all_by_role(:admin)
    @faculty = User.find_all_by_role(:faculty)
    @tas = User.find_all_by_role(:ta)
  end

  def create_faculty
    requires ['admin']
    @faculty = User.new
  end

  def confirm_faculty
    requires ['admin']
    u = User.new(:email => params[:facultyemail], :password => 'password', :password_confirmation => 'password', :role => :faculty, :id =>  User.last.id + 1)
    if(u.save)
    elsif(User.find_by_email(params[:facultyemail]))
      u["errormessage"] = "Email already in use"
    else
      u["errormessage"] = "Email entered is invalid"
    end
    render :json => u.to_json
  end

  def delete_faculty
    requires ['admin']
    u = User.find_by_email(params[:facultyemail])
    u.destroy
    render :json => u.to_json
  end
end
