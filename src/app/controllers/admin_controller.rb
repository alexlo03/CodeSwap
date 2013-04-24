class AdminController < ApplicationController
include ApplicationHelper
  #requires({'role'=>'admin'})
	#List 5 oldest students, admins, and faculty members (teachers)

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def index
    requires({'role'=>'admin'})
    
    @students = User.find_all_by_role_and_deleted_at([:student, :ta], nil).take(5)
    @admins = User.find_all_by_role_and_deleted_at(:admin, nil).take(5)
    @faculty = User.find_all_by_role_and_deleted_at(:faculty, nil).take(5)
    
  end

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def create_faculty
    requires({'role'=>'admin'})
    @faculty = User.new
  end


  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def add_user
    requires({'role'=>'admin'})
    name = params[:name].chomp.split
    u = User.new(
        :email => params[:email],
        :first_name => name[0],
        :last_name => name[1],
        :password => 'password',
        :password_confirmation => 'password',
        :role => params[:role],
        :id =>  User.last.id + 1)
			#Create random password, requires members to respond to email before using the system.
      o =[('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
      u.reset_password_token = (0...12).map{ o[rand(o.length)] }.join
      u.reset_password_sent_at = Time.now
    if(u.save)
      Emailer.delay.signup_confirmation(u)
    elsif(User.find_by_email(params[:email]))
      u["errormessage"] = "Email already in use"
    else
      u["errormessage"] = "Email entered is invalid"
    end
    render :json => u.to_json
  end


  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def delete_user
		#Removes user from the database
		#TODO Cascading deletes?
    requires({'role'=>'admin'})
    u = User.find_by_email(params[:email])
    u.destroy
    render :json => u.to_json
    
  end


	#View all faculty members

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def view_faculty
    requires({'role'=>'admin'})
    @faculty = User.find_all_by_role_and_deleted_at(:faculty, nil)
  end

	#View all admins

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def view_admin
    requires({'role'=>'admin'})
    @admins = User.find_all_by_role_and_deleted_at(:admin, nil)
  end

	#View all students

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def view_students
    requires({'role'=>'admin'})
    @students = User.find_all_by_role_and_deleted_at(:student, nil)
  end


	#View all TAs

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
	#TODO Delete if safe to remove
  def view_tas
    requires({'role'=>'admin'})
    @tas = User.find_all_by_role_and_deleted_at(:ta, nil)
  end

	#view for a specific user

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def view_user_info
    requires ({'role'=>['admin', 'faculty']})
    u = User.find_by_id(params[:id])
    u['student_in'] = u.student_in
    u['ta_in'] = u.ta_in
    u['professor_of'] = u.professor_of
    u['name'] = u.friendly_full_name
    render :json => u.to_json
  end

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def view_recent_activity
    requires({'role'=>'admin'})
    
    currentUsers = User.where('current_sign_in_at not null').order(:current_sign_in_at).reverse
    

    render :json => currentUsers.to_json
  end

	#Searches through users for partial matches of first name, last name, role, and emails.

  ## TODO DOCUMENT
  ## PURPOSE
  # [Route(s)]
  ## * TODO define routes
  # [Params]
  ## * TODO define params
  # [Environment Variables]
  ## * TODO define environment variables
  def search_users
    requires({'role'=>'admin'})
    email = '%'
    firstname = '%'
    lastname = '%'
		#If parameters are present, set the variables equal to the parameters.
    email = '%' + params[:email] + '%' if params[:email] != ''
    firstname = '%' + params[:first_name] + '%' if params[:first_name] != ''
    lastname = '%' + params[:last_name] + '%' if params[:last_name] != ''
    u = User.where('role = ? and deleted_at is null', params[:role])
    total = u.count
		#Do the actual searches
    matching_first_name = User.where('lower(first_name) like ?', firstname.downcase)
    matching_last_name = User.where('lower(last_name) like ?', lastname.downcase)
    matching_email = User.where('lower(email) like ?', email.downcase)
		
		#Add results to return list
    u = u & matching_first_name if matching_first_name
    u = u & matching_last_name if matching_last_name
    u = u & matching_email if matching_email		
    u = u.take(10)

		#Sort list (if option seleced)
    u.order_by(:email) if params[:sortby] == 'email'
    render :json => {:users => u, :count => u.count, :total => total}
  end
end
