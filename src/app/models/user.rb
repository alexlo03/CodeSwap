class User < ActiveRecord::Base
  ROLES = %w[admin faculty ta student]

	has_many :course_groups
  has_many :authentications
  has_and_belongs_to_many :courses

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :deleted_at, :current_sign_in_at


  Devise.reset_password_within = 2.days
  def destroy
    if(deleted_at == nil)
      update_attribute(:deleted_at, Time.current)
    else
      super
    end
  end

  def active_for_authentication?
    super && !deleted_at
  end
  
  def admin?
    role.eql? "admin"
  end

  def faculty?
    role.eql? "faculty"
  end

  def ta?
    role.eql? "ta"
  end

  def student?
    role.eql? "student"
  end

  def full_name
    last_name + ", " + first_name
  end

  def username
    email.split("@")[0]
  end

  def friendly_full_name
		ret = "NO FIRST OR LAST NAME"
		unless first_name.nil? or last_name.nil?
    ret = first_name + " " + last_name
		end
		ret
  end

  def student_in
    Course.find_all_by_id(StudentInCourse.find_all_by_user_id(id).map(&:course_id))
  end 
  
  def ta_in
    Course.find_all_by_id(TaForCourse.find_all_by_user_id(id).map(&:course_id))
  end

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
