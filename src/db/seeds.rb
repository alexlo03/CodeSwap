# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# USERS

# Admins

User.create(:email => "testingseed@seed.com", :first_name => 'Administrator', :last_name => 'Billy', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :first_name => 'Administrator', :last_name => 'Joel', :password => 'password', :password_confirmation => 'password', :role => :admin)


# Faculty

User.create(:email => 'faculty@test.com', :first_name => 'Leonard', :last_name => 'Nimoy', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.2@test.com', :first_name => 'Tom', :last_name => 'Hanks', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.3@test.com', :first_name => 'Jeremiah', :last_name => 'DiCaprio', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.4@test.com', :first_name => 'John', :last_name => 'Locke', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.5@test.com', :first_name => 'Lao', :last_name => 'Tzu', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.6@test.com', :first_name => 'Friedrich', :last_name => 'Nietzsche', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.7@test.com', :first_name => 'Thomas', :last_name => 'Hobbes', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.8@test.com', :first_name => 'Albert', :last_name => 'Einstein', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.9@test.com', :first_name => 'Thomas', :last_name => 'Edison', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.10@test.com', :first_name => 'Nikolai', :last_name => 'Tesla', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.11@test.com', :first_name => 'Galileo', :last_name => 'Galilei', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.12@test.com', :first_name => 'Leonard', :last_name => 'Euler', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.13@test.com', :first_name => 'Benjamin', :last_name => 'Franklin', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.14@test.com', :first_name => 'Barack', :last_name => 'Obama', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.15@test.com', :first_name => 'George', :last_name => 'Bush', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.16@test.com', :first_name => 'Isaac', :last_name => 'Newton', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.17@test.com', :first_name => 'General', :last_name => 'Tso', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.18@test.com', :first_name => 'Monty', :last_name => 'Python', :password => 'password', :password_confirmation => 'password', :role => :faculty)

# Students

User.create(:email => 'student@test.com', :first_name => 'Queen', :last_name => 'Elizabeth', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'student.two@test.com', :first_name => 'Nelson', :last_name => 'Mandela', :password => 'password', :password_confirmation => 'password', :role => :student)


# TAs

User.create(:email => 'ta@test.com', :first_name => 'Mahatma', :last_name => 'Gandhi', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'ta.two@test.com', :first_name => 'Emperor', :last_name => 'Akihito', :password => 'password', :password_confirmation => 'password', :role => :ta)
