class User < ActiveRecord::Base
  ROLES = %w[admin faculty ta student]

  has_many :authentications
  has_and_belongs_to_many :courses

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :deleted_at

  Devise.reset_password_within = 2.days
  
  def active_for_authentication?
    super && !deleted_at
  end
  
  def soft_delete
    update_attribute(:deleted_at, Time.current)
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

  def friendly_full_name
    first_name + " " + last_name
  end

  def student_in
    Course.find_all_by_id(Studentgroup.find_all_by_user_id(id).map(&:course_id))
  end 
  
  def ta_in
    Course.find_all_by_id(Tagroup.find_all_by_user_id(id).map(&:course_id))
  end


  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
