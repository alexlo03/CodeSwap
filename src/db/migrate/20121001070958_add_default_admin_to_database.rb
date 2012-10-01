class AddDefaultAdminToDatabase < ActiveRecord::Migration
  def change
    User.create(:email => 'administrator@test.com', :password => 'password', :password_confirmation => 'password', :role => 'admin')
    User.create(:email => 'faculty.test@test.com', :password => 'password', :password_confirmation => 'password', :role => 'faculty')
    User.create(:email => 'ta.test@test.com', :password => 'password', :password_confirmation => 'password', :role => 'ta')
    User.create(:email => 'student.test@test.com', :password => 'password', :password_confirmation => 'password', :role => 'student')
  end
end
