class User < ActiveRecord::Base
  ROLES = %w[admin faculty ta student]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role

  
  # attr_accessible :title, :body

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

end
