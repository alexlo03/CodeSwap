module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def faculty_count
    User.where(:role => :faculty).count
  end

  def admin_count
    User.where(:role => :admin).count
  end

  def ta_count
    User.where(:role => :ta).count
  end
  
  def student_count
    User.where(:role => :student).count
  end

  def create_and_invite_user(first, last, email, role)
  	#Create random password, requires members to respond to email before using the system.
    o =[('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
    token =  (0...12).map{ o[rand(o.length)] }.join

    user = User.new(:first_name => first, :last_name => last, :email => email, :role => role, :password => token, :password_confirmation => token)
    user.reset_password_token = token    
    user.reset_password_sent_at = Time.now

    if(user.save)
      Emailer.delay.signup_confirmation(user)
      return user
    end  
    
    return nil
    
  end

  def requires(roles)
    unless current_user && roles.include?(current_user.role)
      flash[:error] = 'You do not have permission to view this page. Contact a system administrator if you think this is incorrect.'
      redirect_to root_path
    end
  end


end
