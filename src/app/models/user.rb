class User < ActiveRecord::Base
  ROLES = %w[admin faculty ta student]

  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :created_at, :updated_at

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
