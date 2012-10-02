# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:email => "testingseed@seed.com", :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'faculty@test.com', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'faculty.two@test.com', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'student@test.com', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'student.two@test.com', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'ta@test.com', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'ta.two@test.com', :password => 'password', :password_confirmation => 'password', :role => :ta)
