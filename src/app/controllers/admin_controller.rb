class AdminController < ApplicationController
  
  def index
    requires ['admin']
    @students = User.find_all_by_role(:student)
    @admins = User.find_all_by_role(:admin)
    @faculty = User.find_all_by_role(:faculty).take(5)
    @tas = User.find_all_by_role(:ta)
  end

  def create_faculty
    requires ['admin']
    @faculty = User.new
  end

  def confirm_faculty
    requires ['admin']
    name = params[:facultyname].chomp.split
    u = User.new(
        :email => params[:facultyemail],
        :first_name => name[0],
        :last_name => name[1],
        :password => 'password',
        :password_confirmation => 'password',
        :role => :faculty,
        :id =>  User.last.id + 1)
      o =[('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
      u.reset_password_token = (0...12).map{ o[rand(o.length)] }.join
      u.reset_password_sent_at = Time.now
    if(u.save)
      Emailer.delay.signup_confirmation(u)
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


  def view_faculty
    requires ['admin']
    @faculty = User.find_all_by_role('faculty')
  end

  def search_faculty
    requires ['admin']
    email = '%'
    firstname = '%'
    lastname = '%'
    email = '%' + params[:facultyemail] + '%' if params[:facultyemail] != ''
    firstname = '%' + params[:first_name] + '%' if params[:first_name] != ''
    lastname = '%' + params[:last_name] + '%' if params[:last_name] != ''
    u = User.where('role = "faculty"')
    matching_first_name = User.where('lower(first_name) like ?', firstname.downcase)
    matching_last_name = User.where('lower(last_name) like ?', lastname.downcase)
    matching_email = User.where('lower(email) like ?', email.downcase)
    u = u & matching_first_name if matching_first_name
    u = u & matching_last_name if matching_last_name
    u = u & matching_email if matching_email
    u.order_by(:email) if params[:sortby] == 'email'
    render :json => u.to_json
  end
end
