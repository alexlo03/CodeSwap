class User < ActiveRecord::Base
  ROLES = %w{admin faculty ta student}


	has_many :course_groups
  has_many :authentications
	has_many :student_in_courses
	has_many :ta_for_courses
  has_and_belongs_to_many :courses
	
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :deleted_at, :current_sign_in_at


  Devise.reset_password_within = 2.days

	# Override destroy method for soft deletion
	# [Note]
	## * Deleting a soft deleted user actually deletes user
  def destroy
    if(deleted_at == nil)
      update_attribute(:deleted_at, Time.current)
    else
      super
    end
  end

	
	# Override of devise method active_for_authentication
	# [Note]
	## * Soft deleted users can not login
  def active_for_authentication?
    super && !deleted_at
  end
  	# Metaprogramming magic to set up different
	ROLES.each do |name|
		define_method("#{name}?") {role == name}
	end

	# Full name (last,first)
	# [Return]
	## * {last,first}
	# [Note]
	## * User#friendly_full_name is prefered. It Lets view know if a user is missing part of the name
  def full_name
    "#{last_name},#{first_name}"
  end

	# Username of the user, from email
	# [Return]
	## * Part of email before '@' character
  def username
    email.split("@")[0]
  end
	
	
	# Full name (l)
	# [Return]
	## * firstname lastname
	# [Note]
	## * Returns "NO FIRST OR LAST NAME" if a first or last name is missing
  def friendly_full_name
		ret = "NO FIRST OR LAST NAME"
		unless first_name.nil? or last_name.nil?
    ret = "#{first_name} #{last_name}"
		end
		ret
  end

	# All courses that the user is a student in
	# [Return]
	## * Array of courses
  def student_in
    student_in_courses.collect(&:course)
  end 
  
	# All courses that the user is a ta for
	# [Return]
	## * Array of courses
	def ta_in
		ta_for_courses.collect(&:course)
  end

	
	# All courses that the user is a professor of
	# [Return]
	## * Array of courses
  def professor_of
    Course.find_all_by_user_id(id)
  end

  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
class RegistrationsController < Devise::RegistrationsController

end
