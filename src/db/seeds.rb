# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# USERS

# Admins

User.create(:email => "testingseed@seed.com", :first_name => 'Testing', :last_name => 'seed', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :first_name => 'min', :last_name => 'ad', :password => 'password', :password_confirmation => 'password', :role => :admin)


# Faculty

User.create(:email => 'faculty@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.2@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.3@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.4@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.5@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.6@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.7@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.8@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.9@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.10@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.11@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.12@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.13@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.14@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.15@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.16@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.17@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.18@test.com', :first_name => 'A faculty', :last_name => 'member', :password => 'password', :password_confirmation => 'password', :role => :faculty)

# Students

User.create(:email => 'student@test.com', :first_name => 'student', :last_name => 'studant', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'student.two@test.com', :first_name => 'stu', :last_name => 'dent', :password => 'password', :password_confirmation => 'password', :role => :student)


# TAs

User.create(:email => 'ta@test.com', :first_name => 'teaching', :last_name => 'assistant', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'ta.two@test.com', :first_name => 'spider', :last_name => 'man', :password => 'password', :password_confirmation => 'password', :role => :ta)
