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

	# Total number of active users with faculty role
	# [RETURN]
	## * number of faculty members
  def faculty_count
    User.where(:role => :faculty, :deleted_at => nil).count
  end

	# Total number of active users with admin role
	# [RETURN]
	## * number of admins
  def admin_count
    User.where(:role => :admin, :deleted_at => nil).count
  end

	# Total number of active users with TA role
	# [RETURN]
	## * number of TAs
  def ta_count
    User.where(:role => :ta, :deleted_at => nil).count
  end
  
	# Total number of active users with students role
	# [RETURN]
	## * number of students
  def student_count
    User.where(:role => :student, :deleted_at => nil).count
  end

	# Creates a user, then emails them with a way to activate and authenticate their new account
	# [RETURN]
	## * The created user
	# [NOTE]
	## * Without backgrounding the emailer, this can take a long time
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

	
	# Used for permission control. Accepts a role and a course_id in a hash
	# [PARAMS]
  ## * args is a Hash (example: args = {'role' => [], 'course_id'=>[]})
  def requires(args)

    
    unless (current_user && current_user.role=='admin')
      if current_user && args['role'].include?(current_user.role)
        if(args['course_id'])
          unless (
                  (Course.find_all_by_user_id(current_user.id).include?(Course.find_by_id(args['course_id'])))||
                  (Course.find_by_id(args['course_id']).get_students.include?(current_user.id))||
                  (Course.find_by_id(args['course_id']).get_tas.include?(current_user.id)))
            flash[:error] = 'You do not have permission to access this course. Contact a system administrator if you think this is incorrect.'
            redirect_to '/courses'
          end
        end
      else
        flash[:error] = 'You do not have permission to view this page. Contact a system administrator if you think this is incorrect.'
        redirect_to root_path
      end
    end
  end


end
