class User < ActiveRecord::Base
  ROLES = %w[admin faculty ta student]

  has_many :authentications
  has_and_belongs_to_many :courses
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name

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


  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
